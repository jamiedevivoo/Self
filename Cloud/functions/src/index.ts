import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp()

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

// export const onDailyActivityUpdate = 
// functions.firestore.document("challenes/daily").onUpdate(change => {
//     const after = change.after.data()
//     const payload = {
//         data: {
//             temp: String(after.temp),
//             conditions: after.conditions
//         }
//     }
//     return admin.messaging().sendToTopic("weather_boston-ma-us", payload)
//     .catch(error => {
//         console.error("FCM failed", error)
//     })
// })

export const selectDailyActions = functions.https.onRequest((req, res) => {
    const ref = admin.database().ref("actions");
    ref.once("value").then((snapshot) => {
        console.log(snapshot);
        var updates:{[index:string]:boolean} = {};
        snapshot.forEach((actionSnapshot => {
            updates[actionSnapshot.key+"/daily_action"] = false;
            console.log(actionSnapshot.key, updates);
        }));
        console.log(updates);
        ref.update(updates).then(() => {
            res.status(200).send("Daily actions reset successfully");
        })
        .catch(error => {
            console.error("Daily Action Update Failed", error)
        });
    })
    .catch(error => {
        console.error("Getting Snapshots failed", error)
    });
})

// export const helloWorld = functions.https.onRequest((request, response) => {
//     console.log("HEYY")
//     response.send("Hello from Jamie's Firebase!");
// });