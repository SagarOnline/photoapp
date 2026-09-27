# Sign-in and Sign-up Requirements

## SIGNIN-001: Show sign-in screen to unauthenticated users

Status: Accepted  
Priority: Must  
Phase: MVP

When a user is not signed in, the application MUST display the Sign-in screen with these options:

- Continue with Phone Number
- Continue with Email
- Continue with Google
- Continue with Apple

## SIGNIN-002: Route existing and new accounts

Status: Accepted  
Priority: Must  
Phase: MVP

After the user's phone number or email has been verified, or Google or Apple sign-in has succeeded, the application MUST check whether the account is already registered.

- If the account is registered, the application MUST complete sign-in and display the Hives dashboard.
- If the account is not registered, the application MUST display the Sign-up form described in SIGNIN-006.
- After successful sign-up, the application MUST complete registration and display the Hives dashboard.
- A user MUST complete sign-up before accessing Hive features if their account is not already registered.

## SIGNIN-003: Sign in with a phone number

Status: Accepted  
Priority: Must  
Phase: MVP

The phone sign-in flow MUST allow the user to select a country code from a dropdown and enter a phone number. A country code is required before the user can continue.

When the user continues with a valid phone number, the application MUST send a four-digit verification code to that number and allow the user to enter the code. The application MUST verify the entered code before continuing to SIGNIN-002.

## SIGNIN-004: Sign in with email

Status: Accepted  
Priority: Must  
Phase: MVP

The email sign-in flow MUST allow the user to enter an email address. When the user continues with a valid email address, the application MUST send a four-digit verification code to that address and allow the user to enter the code. The application MUST verify the entered code before continuing to SIGNIN-002.

## SIGNIN-005: Sign in with Google or Apple

Status: Accepted  
Priority: Must  
Phase: MVP

The Google and Apple options MUST use the respective provider's single sign-on flow. After the provider confirms the user's identity, the application MUST continue to SIGNIN-002.

## SIGNIN-006: Collect profile details for new accounts

Status: Accepted  
Priority: Must  
Phase: MVP

The Sign-up form MUST collect the following information from a user whose verified account is not already registered:

- Name
- Gender
- Birth date

The application MUST require all three values to complete sign-up.
