const express = require('express')
const app = express()
const port = 3000
const bodyParser = require('body-parser')
const fs = require('fs')

app.use(bodyParser.json())
app.use(bodyParser.raw({limit: '3mb'}))

app.get('/', (req, res) => res.send('BIRDWATCHING SIM SERVER IS ALIVE!'))

app.get('/highscores', (req, res) => {
	let response = {
		'top5': [
			{
				pos: 1,
				name: 'Robin',
				score: 32
			}
		]
	}
	res.send(response)
})

app.post('/highscores', (req, res) => {
	console.log(req.body)
	fs.writeFile('pruttgubbe', req.body, function(err) {
		if (err) {
			console.log('fuken failed to save file')
		} else {
			console.log('ok evidence saved')
		}
	})

	res.send()
})

app.listen(port, () => console.log(`WE RUNNIN ON PORT ${port}!`))
