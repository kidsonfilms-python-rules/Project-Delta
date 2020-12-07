const functions = require('firebase-functions');
var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
const nodemailer = require('nodemailer');
const cors = require('cors')({ origin: true });
const admin = require('firebase-admin');

const mailgun = require("mailgun-js");
const DOMAIN = 'automailer.utsavsac.org';
const api_key = '2084afdb3425e3de7e2ded254dcf1001-0d2e38f7-f141d9cd';
const mg = mailgun({ apiKey: api_key, domain: DOMAIN });

admin.initializeApp(functions.config().firebase);

exports.sendEventNotification = functions.firestore.document('/Schedule/{documentId}').onWrite(async snapshot => {
    const item = snapshot.after.data();
    const payload = {
        notification: {
            title: 'The Schedule has changed!',
            body: `${item.name} has been added or modified.`,
        },
        topic: 'schedule',
    };
    let response = await admin.messaging().send(payload);
    console.log(response);
});

exports.sendAnnouncementNotification = functions.firestore.document('/Announcements/{documentId}').onWrite(async snapshot => {
    const item = snapshot.after.data();
    const payload = {
        notification: {
            title: 'New Announcement!',
            body: `${item.body}`,
        },
        topic: 'schedule',
    };
    let response = await admin.messaging().send(payload);
    console.log(response);
});



function mailConfirm(req, res) {
    function isChecked(val) {
        if (val === 'on') {
            return "checked='true'"
        } else if (val === 'null') {
            return ''
        }
        return ''
    }

    
 
    const data = {
        from: 'Utsav Events Team <no-reply@automailer.utsavsac.org>',
        to: req.body.email,
        cc: 'utsavpr@gmail.com',
        subject: 'Confirmation for 2020 Bijoya Registration #' + Math.floor(Math.random() * (999999 - 100000 + 1) + 100000).toString(),
        html: `
        <body marginheight="0" topmargin="0" marginwidth="0" style="margin: 0px; background-color: #f2f3f8;" leftmargin="0">
            <!--100% body table-->
            <table cellspacing="0" border="0" cellpadding="0" width="100%" bgcolor="#f2f3f8"
                style="@import url(https://fonts.googleapis.com/css?family=Rubik:300,400,500,700|Open+Sans:300,400,600,700); font-family: 'Open Sans', sans-serif;">
                <tr>
                    <td>
                        <table style="background-color: #f2f3f8; max-width:670px;  margin:0 auto;" width="100%" border="0"
                            align="center" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="height:80px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align:center;">
                                    <a href="https://utsavsac.org" title="Go to Utsav's Homepage" target="_blank">
                                        <img width="300"
                                            src="https://firebasestorage.googleapis.com/v0/b/project-delta-db6b3.appspot.com/o/6aea32_f7759b91e229423db448d1d4dbed65ee_mv2.gif?alt=media&token=25a25344-09f2-4732-8cc5-0236decd2f19"
                                            title="Go to Utsav's Homepage" alt="Go to Utsav's Homepage">
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td style="height:20px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"
                                        style="max-width:670px;background:#fff; border-radius:3px; text-align:center;-webkit-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);-moz-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);box-shadow:0 6px 18px 0 rgba(0,0,0,.06);">
                                        <tr>
                                            <td style="height:40px;">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:0 35px;">
                                                <h1
                                                    style="color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;">
                                                    Confirmation for Your Registration: Bijoya Lunch-n-Adda</h1>
                                                <span
                                                    style="display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;"></span>
                                                <p style="color:#455056; font-size:15px;line-height:24px; margin:0;">
                                                    Date: <b>Nov 8</b> <br> 
                                                    Time: <b>Food pickup between 1-2pm, Zoom adda from 2.30pm onward. </b><br>
                                                    Venue:  <b>Zoom - link will be shared few days before event </b> <br><br>
                                                    Name: <b>${req.body.name}</b> <br>
                                                    Total order: <b>${parseInt(req.body.members) + parseInt(req.body.guests)}</b> <br> <br>
                                                    <p style="text-align: start; margin-left: 10vw;">
                                                Family Members: <b>${req.body.members}</b> <br>
                                                Guests: <b>${req.body.guests}</b> <br>
                                                Amount Payable: <b>$${parseInt(req.body.guests)*7}</b><br>
                                                Menu choice: <b>${req.body.menu}</b><br>
                                            </p>
                                                    <p style="color:#455056; font-size:15px;line-height:24px; margin:0; padding: 10px;">
                                                    You will recieve another email with more details about food pickup few days before the event. <br> <br>
                                                    If you want to change your requested services, please re-fill the <a style="color: rgb(0, 0, 0); text-decoration: none; font-weight: bold;" href="https://kidsonfilms-python-rules.github.io/DP2020RegWebsite/">Registration Form here.</a> <br><br>
                                                    If you have any questions or issues, please contact us at <a style="color: rgb(0, 0, 0); text-decoration: none; font-weight: bold;" href="mailto:Utsav Events Team <utsavpr@gmail.com>">utsavpr@gmail.com</a>
        
                                                </p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height:40px;">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            <tr>
                                <td style="height:20px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align:center;">
                                    <p
                                        style="font-size:14px; color:rgba(69, 80, 86, 0.7411764705882353); line-height:18px; margin:0 0 0;">
                                        &copy; <strong><a style="color: gray; text-decoration: none; "
                                                href="https://www.utsavsac.org"> www.utsavsac.org</a></strong></p>
                                                <p
                                        style="font-size:14px; color:rgba(69, 80, 86, 0.7411764705882353); line-height:18px; margin:0 0 0;">
                                        <strong><a style="color: gray; text-decoration: none; "
                                                href="https://github.com/kidsonfilms-python-rules">Powered by KidsonX Tech</a></strong></p>
                                </td>
                            </tr>
                            <tr>
                                <td style="height:80px;">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <!--/100% body table-->
        </body>
        ` // email content in HTML
    };
    mg.messages().send(data, function (error, body) {
        body ? res.status(200).send('Email Sent Successfullly !') : res.status(500).send(error);
    });


    // const mailOptions = {
    //     from: 'Utsav Events Team <postmaster@automailer.utsavsac.org>', // Something like: Jane Doe <janedoe@gmail.com>
    //     to: req.body.email,
    //     bcc: 'Utsav Confirmation <utsavpr@gmail.com>',
    //     subject: 'Confirmation for Durga Puja Registration #' + Math.floor(Math.random() * (999999 - 100000 + 1) + 100000).toString(), // email subject
    //     html: `

    //     <body marginheight="0" topmargin="0" marginwidth="0" style="margin: 0px; background-color: #f2f3f8;" leftmargin="0">
    //         <!--100% body table-->
    //         <table cellspacing="0" border="0" cellpadding="0" width="100%" bgcolor="#f2f3f8"
    //             style="@import url(https://fonts.googleapis.com/css?family=Rubik:300,400,500,700|Open+Sans:300,400,600,700); font-family: 'Open Sans', sans-serif;">
    //             <tr>
    //                 <td>
    //                     <table style="background-color: #f2f3f8; max-width:670px;  margin:0 auto;" width="100%" border="0"
    //                         align="center" cellpadding="0" cellspacing="0">
    //                         <tr>
    //                             <td style="height:80px;">&nbsp;</td>
    //                         </tr>
    //                         <tr>
    //                             <td style="text-align:center;">
    //                                 <a href="https://utsavsac.org" title="Go to Utsav's Homepage" target="_blank">
    //                                     <img width="300"
    //                                         src="https://firebasestorage.googleapis.com/v0/b/project-delta-db6b3.appspot.com/o/6aea32_f7759b91e229423db448d1d4dbed65ee_mv2.gif?alt=media&token=25a25344-09f2-4732-8cc5-0236decd2f19"
    //                                         title="Go to Utsav's Homepage" alt="Go to Utsav's Homepage">
    //                                 </a>
    //                             </td>
    //                         </tr>
    //                         <tr>
    //                             <td style="height:20px;">&nbsp;</td>
    //                         </tr>
    //                         <tr>
    //                             <td>
    //                                 <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"
    //                                     style="max-width:670px;background:#fff; border-radius:3px; text-align:center;-webkit-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);-moz-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);box-shadow:0 6px 18px 0 rgba(0,0,0,.06);">
    //                                     <tr>
    //                                         <td style="height:40px;">&nbsp;</td>
    //                                     </tr>
    //                                     <tr>
    //                                         <td style="padding:0 35px;">
    //                                             <h1
    //                                                 style="color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;">
    //                                                 Confirmation for Your Registration for Durga Puja 2020 Services</h1>
    //                                             <span
    //                                                 style="display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;"></span>
    //                                             <p style="color:#455056; font-size:15px;line-height:24px; margin:0;">
    //                                                 Date of Service: <b>October 24</b> <br> <br>
    //                                                 Venue: <b>Sri Siddhi Vinayaka Temple, <br> 4679 Aldona Ln, Sacramento, CA 95841</b> <br> <br>
    //                                                 These are the services you have requested: <br>
    //                                                 <p style="text-align: start; margin-left: 10vw;">
    //                                                     <input type="checkbox" name="" id=""  ${isChecked(req.body.driveby)}>
    //                                                     <b>Driveby Darshan</b> <br>
    //                                                     <input type="checkbox" name="" id="" onclick="return false;" ${isChecked(req.body.bhog)}> <b>Bhog Pickup/Delivery</b>
    //                                                     <br>
    //                                                     <input type="checkbox" name="" id="" onclick="return false;" ${isChecked(req.body.prasad)}>
    //                                                     <b>Prasad Pickup</b> <br>
    //                                                 </p>
    //                                                 <p style="color:#455056; font-size:15px;line-height:24px; margin:0; padding: 10px;">
    //                                                 You will recieve another email with more details (time windows) few days before the event. <br> <br>
    //                                                 If you want to change your requested services, please fill out the <a style="color: rgb(0, 0, 0); text-decoration: none; font-weight: bold;" href="https://kidsonfilms-python-rules.github.io/DP2020RegWebsite/">Registration Form Here</a> <br><br>
    //                                                 If you have any questions or issues, please contact us at <a style="color: rgb(0, 0, 0); text-decoration: none; font-weight: bold;" href="mailto:Utsav Events Team <utsavpr@gmail.com>">utsavpr@gmail.com</a>
        
    //                                             </p>
    //                                         </td>
    //                                     </tr>
    //                                     <tr>
    //                                         <td style="height:40px;">&nbsp;</td>
    //                                     </tr>
    //                                 </table>
    //                             </td>
    //                         <tr>
    //                             <td style="height:20px;">&nbsp;</td>
    //                         </tr>
    //                         <tr>
    //                             <td style="text-align:center;">
    //                                 <p
    //                                     style="font-size:14px; color:rgba(69, 80, 86, 0.7411764705882353); line-height:18px; margin:0 0 0;">
    //                                     &copy; <strong><a style="color: gray; text-decoration: none; "
    //                                             href="https://www.utsavsac.org"> www.utsavsac.org</a></strong></p>
    //                                             <p
    //                                     style="font-size:14px; color:rgba(69, 80, 86, 0.7411764705882353); line-height:18px; margin:0 0 0;">
    //                                     <strong><a style="color: gray; text-decoration: none; "
    //                                             href="https://github.com/kidsonfilms-python-rules">Powered by KidsonX Tech</a></strong></p>
    //                             </td>
    //                         </tr>
    //                         <tr>
    //                             <td style="height:80px;">&nbsp;</td>
    //                         </tr>
    //                     </table>
    //                 </td>
    //             </tr>
    //         </table>
    //         <!--/100% body table-->
    //     </body>
    //     ` // email content in HTML
    // };

    // return transporter.sendMail(mailOptions, (erro, info) => {
    //     if (erro) {
    //         res.send(erro.toString());
    //     }
    //     res.send(`Sent Email to ${req.body.email}`);
    // });
}


// Take the text parameter passed to this HTTP endpoint and insert it into 
// Cloud Firestore under the path /messages/:documentId/original
exports.postRegDetails = functions.https.onRequest(async (req, res) => {


    cors(req, res, () => {

        mailConfirm(req, res)
        // Add this record in the firestore database    
        var userObject = {
            name: req.body.name,
            email: req.body.email,
            members: req.body.members,
            guests: req.body.guests,
            zipcode: req.body.zipcode,
            menu: req.body.menu,
        };

        return admin.firestore().doc('bhogReg/' + req.body.email).set(userObject);


    })
});




// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
