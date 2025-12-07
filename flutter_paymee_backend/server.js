const express = require('express');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());

app.get('/payment/success', (req, res) => res.send('Payment Success!'));
app.get('/payment/cart', (req, res) => res.send('Payment Cancelled'));
app.post('/payment/webhook', (req, res) => {
    console.log('Webhook received:', req.body);
    res.sendStatus(200);
});

app.listen(3000, () => console.log('Server running on port 3000'));
