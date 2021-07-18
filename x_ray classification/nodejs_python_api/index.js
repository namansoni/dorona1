require('dotenv').config()
const express = require('express')
const app = express()
const multer = require('multer')
const upload = multer({ dest: 'imgs/' })
const fs = require('fs')


app.post('/xray', upload.single('image'), (req, res) => {
    try {
        console.log('hii')
        const { spawn } = require('child_process');
        file = req.file
        const pyProg = spawn('python', ['predict.py', file.destination, file.filename]);
        j = ''
        pyProg.stdout.on('data', function (data) {
            j = '' + data
            console.log(typeof j);
            m = j.split(' ')
            console.log(m)
            fs.unlinkSync(req.file.path)
            res.status(200).send({ 'COVID': m[0], 'Lung Infection': m[1], 'Normal': m[2] })
        });
    } catch {
        res.status(400).send('Error')
    }
})
app.listen(process.env.PORT || 3000, function () {
    console.log("Express server listening on port %d in %s mode", this.address().port, app.settings.env);
})