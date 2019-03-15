#!/usr/bin/env node

'use strict'

const Imap = require('imap'),
      events = require('events'),
      eventEmitter = new events.EventEmitter(),
      execFile = require('child_process').execFile


function imapConnection(config)  {
    let account = new Imap({
        user: config.user,
        password: config.password,
        host: config.host,
        port: config.port,
        tls: config.tls,
        tlsOptions: config.tlsOptions
    })


    function connectAndWait(imap, reconnectTries = { times: 0, sinceLast: Date.now() }) {
        imap.connect()
        imap.once('ready', () => {
            imap.openBox(config.folder, true, err => {
                if (err)
                    eventEmitter.emit('error', err)

                imap.on('mail', n => {
                    eventEmitter.emit('mail', config.accountLabel, n)
                })
            })
        })

        imap.once('error', err => {
            if (reconnectTries.times <= 5) {
                if (Date.now() - reconnectTries.sinceLast >= 300000)
                    reconnectTries.times = 1
                else
                    reconnectTries.times += 1

                reconnectTries.sinceLast = Date.now()
                imap.removeAllListeners()

                console.error(`Reconnecting ${config.accountLabel}`)
                imap = imapConnection(config)
            } else
                eventEmitter.emit('error', err, config.accountLabel)
        })

        return imap 
    }

    return connectAndWait(account)
}

function readJSON(f) {
    try {
        return JSON.parse(require('fs').readFileSync(f, "UTF-8"))
    } catch(e) {
        console.error(e)
        process.exit(1)
    }
}

eventEmitter.on('mail', (name, n) => {
    execFile('/home/cloud/bin/mailsync.sh', [name, n], (err, stdout, stderr) => {
        if (err) {
            console.error(stderr)
            process.exit(1)
        }

        console.log(stdout)
    })
})

eventEmitter.on('error', (err, name) => {
    console.error(err)
    process.exit(1)
})

const conns = readJSON("/home/cloud/.config/idlemail/config.json").map(imapConnection)

process.on('exit', () => Array.isArray(conns) && conns.forEach(a => a && a.end()))
