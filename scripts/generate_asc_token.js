#!/usr/bin/env node
/**
 * App Store Connect API Token Generator
 * 
 * Usage: node generate_asc_token.js
 * 
 * Requires:
 *   - Private key file: ~/.appstoreconnect/AuthKey_{KEY_ID}.p8
 *   - npm install jose
 * 
 * Output: JWT token to stdout
 */

const { SignJWT, importPKCS8 } = require('jose');
const fs = require('fs');
const path = require('path');

const KEY_ID = '7QJ8VTF4TQ';
const ISSUER_ID = 'b2a00f88-3a8d-40d0-b148-1f1db92e10b7';

async function generateToken() {
  const keyPath = path.join(process.env.HOME, '.appstoreconnect', `AuthKey_${KEY_ID}.p8`);
  
  if (!fs.existsSync(keyPath)) {
    console.error(`Error: Key file not found at ${keyPath}`);
    process.exit(1);
  }
  
  const privateKeyPEM = fs.readFileSync(keyPath, 'utf8');
  const privateKey = await importPKCS8(privateKeyPEM, 'ES256');
  const now = Math.floor(Date.now() / 1000);
  
  const token = await new SignJWT({ iss: ISSUER_ID })
    .setProtectedHeader({ alg: 'ES256', kid: KEY_ID })
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .setAudience('appstoreconnect')
    .sign(privateKey);
  
  console.log(token);
}

generateToken().catch(err => {
  console.error('Error generating token:', err.message);
  process.exit(1);
});
