#!/bin/bash

mkdir -p verification-guide
cd verification-guide

create_html() {
  filename=$1
  title=$2
  content=$3

  cat <<EOF > $filename
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>$title</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2rem; line-height: 1.6; max-width: 900px; }
    h1, h2 { color: #2c3e50; }
    pre, code { background: #f4f4f4; padding: 1rem; display: block; border-radius: 5px; }
  </style>
</head>
<body>
  <h1>$title</h1>
  $content
</body>
</html>
EOF
}

create_html "01-introduction.html" "Introduction : Pourquoi vérifier un compte ?" "<p>La vérification permet de confirmer l'identité de l'utilisateur par email ou SMS. Cela sécurise l'accès, réduit les fraudes, et améliore la fiabilité des données.</p>"

create_html "02-dependances.html" "Dépendances et outils" "<ul><li><strong>Node.js Packages :</strong> express, mongoose, dotenv, nodemailer, twilio</li><li><strong>Outils email :</strong> Gmail, Mailtrap, SendGrid</li><li><strong>Outils SMS :</strong> Twilio, Vonage</li></ul>"

create_html "03-installation.html" "Installation du projet" "<pre><code>npm init -y
npm install express mongoose dotenv nodemailer twilio</code></pre>"

create_html "04-env-config.html" "Fichier .env et Configuration" "<pre><code>PORT=3000
MONGO_URI=mongodb://localhost:27017/auth
EMAIL_USER=votre-email@gmail.com
EMAIL_PASS=motdepasse
TWILIO_SID=xxxxx
TWILIO_TOKEN=xxxxx
TWILIO_PHONE=+33700000000</code></pre>"

create_html "05-model.html" "Modèle utilisateur (User)" "<pre><code>import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  phone: String,
  isVerified: { type: Boolean, default: false },
  otp: String,
  otpExpires: Date
});

export default mongoose.model('User', userSchema);</code></pre>"

create_html "06-mailer.html" "Utilitaire Mailer" "<pre><code>import nodemailer from 'nodemailer';

export const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

export const sendVerificationEmail = (to, code) => {
  return transporter.sendMail({
    from: process.env.EMAIL_USER,
    to,
    subject: 'Code de vérification',
    text: 'Votre code est : ' + code
  });
};</code></pre>"

echo "Tous les fichiers HTML ont été générés dans le dossier ./verification-guide"
