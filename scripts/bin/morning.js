// Good morning, love.

const fs = require('fs'),
      nodemailer = require('nodemailer'),
      org = require('org'),
      os = require('os'),
      readline = require('readline')

const header = /^\*+\s+TODO/,
      sched  = /SCHEDULED:\s+<(\d{4})-(\d{1,2})-(\d{1,2})/

function assert(x, str) {
    if (!x) {
        console.error(`Missing env var: ${str}`)
        process.exit(1)
    }

    return x
}

const sendaddress = assert(process.env.SENDADDRESS, "SENDADDRESS"),
      pass = assert(process.env.PASSWORD, "PASSWORD"),
      recipients = assert(process.env.RECIPIENTS.split(','), "RECIPIENTS")

function sendMail(recipients, from, pass, msg) {
    const url = `smtp://${from}:${pass}@smtp.gmail.com`,
          sender = nodemailer.createTransport(url),
          opts = {
              from: `"Good Morning, V-Dem!" <${from}>`,
              to: recipients.join(','),
              subject: 'Daily Briefing',
              text: msg
          }

    sender.sendMail(opts, (err, info) => err ? console.error(err) : console.log("Sent summary"))
}

function parse(arr, tree = []) {
    const id = arr.findIndex(n => header.test(n))
    if (id == -1)
        return tree
    
    const match = parseSchedule(arr.slice(id + 1))
    if (match) {
        const [year, month, day] = match.slice(1, 4)
        tree.push({
            text: arr[id].replace(header, "-"),
            scheduled: new Date(year, month - 1, day)
        })
    }

    return parse(arr.slice(id + 1), tree)
}

function parseSchedule(arr) {
    if (arr.length == 0 || header.test(arr[0]))
        return null
    
    return arr[0].match(sched) || parseSchedule(arr.slice(1))
}

const raw = fs.readFileSync(`${os.homedir()}/notes/todo.org`, 'UTF-8').split('\n'),
      todos = parse(raw).filter(n => n.scheduled.getTime() <= Date.now())
                        .map(n => `${n.text}\n\tscheduled => ${n.scheduled.toDateString()}`)
                        .join('\n\n')

sendMail(recipients, sendaddress, pass, todos)
