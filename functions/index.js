const functions = require('firebase-functions');
const admin = require('firebase-admin');
const distanceBetweenPoints = require('distance-between-geocoordinates');
admin.initializeApp();
const firestore = admin.firestore();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.onLocationCreate = functions
    .firestore
    .document('/Locations/{adminArea}/{adminArea1}/{subAdminArea}/{subAdminArea1}/{pincode}/{pincode1}/{userId}')
    .onCreate(async (snapshot, context) => {
        const adminArea = context.params.adminArea;
        const subAdminArea = context.params.subAdminArea;
        const pincode = context.params.pincode;
        const userId = context.params.userId;
        const point1 = {
            lat: snapshot.data()['latitude'],
            lng: snapshot.data()['longitude'],
        };
        //All locations reference in user's pincode
        const locationReference = admin
            .firestore()
            .collection("Locations")
            .doc(adminArea)
            .collection(adminArea)
            .doc(subAdminArea)
            .collection(subAdminArea)
            .doc(pincode)
            .collection(pincode);
        const querySnapshot = await locationReference.get();
        count = 0;
        querySnapshot.forEach(doc => {
            if (doc.exists) {
                if (doc.id != userId) {
                    const point2 = {
                        lat: doc.data()['latitude'],
                        lng: doc.data()['longitude'],
                    };
                    const result = distanceBetweenPoints(point1, point2, "m");
                    console.log(result);
                    if (result['distance'] <= 20) {
                        count = count + 1;
                    }
                }
            }
        });
        if (count > 0) {
            const userRef = admin.firestore().collection("Users").doc(userId);
            const userDoc = await userRef.get();
            const androidNotificationToken = userDoc.data()['androidNotificationToken'];
            const message = {
                notification: {
                    body: `${count} persons near you are covid positive(<10m)`,
                    title: "Dorona Alert",
                    
                },
                token: androidNotificationToken,
                android: {
                    notification: {
                        
                        tag:userId+"fromfcm",
                        notification_priority:"PRIORITY_DEFAULT"
                    },
                    priority: 'high',
                    ttl: 0
                }

            };
            admin.messaging().send(message).then(res => {
                console.log("message sent successfully ", res);
            }).catch(error => {
                console.log("Error : ", error);
            });
        }

    });
exports.onLocationUpdate = functions
    .firestore
    .document('/Locations/{adminArea}/{adminArea1}/{subAdminArea}/{subAdminArea1}/{pincode}/{pincode1}/{userId}')
    .onUpdate(async (change, context) => {
        const adminArea = context.params.adminArea;
        const subAdminArea = context.params.subAdminArea;
        const pincode = context.params.pincode;
        const userId = context.params.userId;
        const point1 = {
            lat: change.after.data()['latitude'],
            lng: change.after.data()['longitude'],
        };
        //All locations reference in user's pincode
        const locationReference = admin
            .firestore()
            .collection("Locations")
            .doc(adminArea)
            .collection(adminArea)
            .doc(subAdminArea)
            .collection(subAdminArea)
            .doc(pincode)
            .collection(pincode);
        const querySnapshot = await locationReference.get();
        count = 0;
        querySnapshot.forEach(doc => {
            if (doc.exists) {
                if (doc.id != userId) {
                    const point2 = {
                        lat: doc.data()['latitude'],
                        lng: doc.data()['longitude'],
                    };
                    const result = distanceBetweenPoints(point1, point2, "m");
                    console.log(result);
                    if (result['distance'] <= 20) {
                        count = count + 1;
                    }
                }
            }
        });
        if (count > 0) {
            const userRef = admin.firestore().collection("Users").doc(userId);
            const userDoc = await userRef.get();
            const androidNotificationToken = userDoc.data()['androidNotificationToken'];
            const message = {
                notification: {
                    body: `${count} persons near you are covid positive(<10m)`,
                    title: "Dorona Alert",
                },
                token: androidNotificationToken,
                android: {
                    notification: {
                        
                        tag:userId+"fromfcm",
                        notification_priority:"PRIORITY_DEFAULT"
                    },
                    priority: 'high',
                    ttl: 0
                }

            };
            admin.messaging().send(message).then(res => {
                console.log("message sent successfully ", res);
            }).catch(error => {
                console.log("Error : ", error);
            });
        }

    });
exports.onUserStatusUpdate = functions
    .firestore
    .document('/status/{userId}')
    .onUpdate(async (change, context) => {
        
            const userId = context.params.userId;
            const userRef = admin.firestore().collection("Users").doc(userId);
            const userDoc = await userRef.get();
            const androidNotificationToken = userDoc.data()['androidNotificationToken'];
            const message = {
                notification: {
                    body: 'Your covid report has come',
                    title: "Covid Report",
                },
                token: androidNotificationToken,
                android: {
                    notification: {
                        
                        tag:userId+"covidReport",
                        notification_priority:"PRIORITY_DEFAULT"
                    },
                    priority: 'high',
                    ttl: 0
                }

            };
            admin.messaging().send(message).then(res => {
                console.log("message sent successfully ", res);
            }).catch(error => {
                console.log("Error : ", error);
            });
        
    });
