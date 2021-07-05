import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
// const fcm = admin.messaging();

exports.addEventRegistration = functions.firestore.document('/events/{eventId}/registrations/{registrationId}').onCreate(async (newRegistration, context) => {
    const eventId = context.params.eventId;
    const docRef = db.doc('/events/' + eventId);

    return docRef.get().then(snap => {
        // Prepare new amount value
        const registrationCount = snap.get('registrationAmount') + 1;
        const data = { 'registrationAmount': registrationCount }

        // run update on event
        return docRef.update(data)
    })
});

exports.removeEventRegistration = functions.firestore.document('/events/{eventId}/registrations/{registrationId}').onDelete(async (oldRegistrationDoc, context) => {
    const eventId = context.params.eventId;
    const docRef = db.doc('/events/' + eventId);

    // Hacky way
    const oldRegistration = JSON.stringify(oldRegistrationDoc.data());
    const additionalAmount: number = JSON.parse(oldRegistration).additionalAmount;

    let amountOfOldRegistrations = 1;
    if (additionalAmount > 0) {
        amountOfOldRegistrations += additionalAmount;
    }

    return docRef.get().then(snap => {
        // Prepare new amount value
        const registrationAmount = snap.get('registrationAmount') - amountOfOldRegistrations;
        const data = { 'registrationAmount': registrationAmount }

        // run update on event
        return docRef.update(data);
    })
});
