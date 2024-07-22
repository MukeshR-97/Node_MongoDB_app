const express = require('express');
const MongoClient = require('mongodb').MongoClient;
const app = express();
const port = 3000;

// Connection URIs for MongoDB instances
const nodeIp = '35.172.234.239'; // Replace with actual Node IP
const clients = {
  client1: `mongodb://mongodb-0.mongodb-headless.client1.svc.cluster.local:27017/dbname`,
  client2: `mongodb://${nodeIp}:32018/dbname`,
  client3: `mongodb://${nodeIp}:32019/dbname`,
  client4: `mongodb://${nodeIp}:32020/dbname`,
  client5: `mongodb://${nodeIp}:32021/dbname`,
  client6: `mongodb://${nodeIp}:32022/dbname`
};

function getClientDatabase(clientId) {
  const uri = clients[clientId];
  if (!uri) {
    throw new Error('Invalid client ID');
  }
  return MongoClient.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(client => client.db())
    .catch(err => {
      console.error(`Failed to connect to MongoDB for client ${clientId}`, err);
      throw err;
    });
}

app.get('/data', async (req, res) => {
  const clientId = req.query.clientId; // Or retrieve from session, auth token, etc.
  try {
    const db = await getClientDatabase(clientId);
    const data = await db.collection('collectionName').find({}).toArray();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch data' });
  }
});

app.listen(port, () => {
  console.log(`Backend app listening at http://localhost:${port}`);
});
