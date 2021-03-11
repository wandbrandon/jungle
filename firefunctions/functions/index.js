const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
  .document('chats/{groupID}/messages/{message}')
  .onCreate((snap, context) => {
    console.log(' ---------------- start function ---------------- ')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.fromUID
    const idTo = doc.toUID
    const contentMessage = doc.message

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('uid', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          console.log(`Found user to: ${userTo.data().name}`)
          if (userTo.data().pushToken) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('uid', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                  console.log(`Found user from: ${userFrom.data().name}`)
                  const payload = {
                    notification: {
                      title: 'Jungle',
                      body: `${userFrom.data().name} sent you a message.`,
                      sound: 'default'
                    }
                  }    
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          } else {
            console.log('Can not find pushToken target user')
          }
        })
      })
    return null
  })

  exports.sendNotificationMatch = functions.firestore
  .document('chats/{groupID}')
  .onCreate((snap, context) => {
    console.log('new chatroom has been made')
    const doc = snap.data()
    const userUIDs = doc.UIDs
    console.log(userUIDs)

    admin
      .firestore()
      .collection('users')
      .where('uid' ,'in', userUIDs)
      .get()
      .then(qsnap => {qsnap.forEach(userTo => {
        console.log(`got one: ${userTo.data().name}`)
        if(userTo.data().pushToken){
          const payload = {
            notification: {
              title: 'Jungle',
              body: "You've got a match!",
              sound: 'default',
              click_action: "FLUTTER_NOTIFICATION_CLICK",
            }
          }    
          admin
            .messaging()
            .sendToDevice(userTo.data().pushToken, payload)
            .then(response => {
              console.log('Successfully sent message:', response)
            })
            .catch(error => {
              console.log('Error sending message:', error)
            })
        } else {
          console.log('Can not find pushToken target user')
        }
      })
    })
    return null
  })
