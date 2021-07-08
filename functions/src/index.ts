import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
// const fcm = admin.messaging();

exports.addEventRegistration = functions.firestore.document('/events/{eventId}/registrations/{registrationId}').onCreate(async (newRegistration, context) => {
    const eventId = context.params.eventId;
    const docRef = db.doc('/events/' + eventId);
    const userId = context.params.registrationId;

    return docRef.get().then(snap => {
        // Prepare new amount value
        let registeredUsers: string[];
        if (snap.get('registeredUsers') == null) {
            registeredUsers = [];
        } else {
            registeredUsers = snap.get('registeredUsers');
        }
        if (userId == null || registeredUsers.includes(userId)) {
            return;
        }
        const registrationCount = snap.get('registrationAmount') + 1;
        const data = {
            'registrationAmount': registrationCount,
            'registeredUsers': admin.firestore.FieldValue.arrayUnion(userId),
        };
        // run update on event
        return docRef.update(data)
    })
});

exports.removeEventRegistration = functions.firestore.document('/events/{eventId}/registrations/{registrationId}').onDelete(async (oldRegistrationDoc, context) => {
    const eventId = context.params.eventId;
    const docRef = db.doc('/events/' + eventId);
    const userId = context.params.registrationId;

    // Hacky way
    const oldRegistration = JSON.stringify(oldRegistrationDoc.data());
    const additionalAmount: number = JSON.parse(oldRegistration).additionalAmount;

    let amountOfOldRegistrations = 1;
    if (additionalAmount > 0) {
        amountOfOldRegistrations += additionalAmount;
    }

    return docRef.get().then(snap => {
        // Prepare new amount value

        if (snap.get('registeredUsers') == null) {
            return;
        }

        const registeredUsers: string[] = snap.get('registeredUsers');
        if (userId == null || !registeredUsers.includes(userId)) {
            return;
        }

        const registrationAmount = snap.get('registrationAmount') - amountOfOldRegistrations;
        const data = {
            'registrationAmount': registrationAmount,
            'registeredUsers': admin.firestore.FieldValue.arrayRemove(userId),
        };

        // run update on event
        return docRef.update(data);
    })
});
