const functions = require('firebase-functions');
const firebase_tools = require('firebase-tools');
const admin = require('firebase-admin');
admin.initializeApp();

exports.deleteCollection = functions.runWith({ timeoutSeconds: 540, memory: '2GB' }).region("europe-west3").https.onCall((request, response) => {
    const path = request['path']; 
    console.log('User has requested to delete ' + path);
    return firebase_tools.firestore.delete(path, {
        project: process.env.GCLOUD_PROJECT,
        recursive: true,
        yes: true,
        token: functions.config().fb.token
    }).then(() => { return { path: path }; });
});

exports.deleteAccount = functions.runWith({timeoutSeconds: 540, memory: '2GB'}).region("europe-west3").https.onCall((request, response) => {
    const path = request['path']; 
    console.log('User has requested to delete account on path: ' + path);
    return firebase_tools.firestore.delete(path, {
        project: process.env.GCLOUD_PROJECT,
        recursive: true,
        yes: true,
        token: functions.config().fb.token
    }).then(() => { return { path: path }; });
});