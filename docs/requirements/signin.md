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

- For these requirements, an account is registered only when the application has persisted a profile associated with the authenticated account and that profile contains all required details in SIGNIN-006. An authentication identity or active session alone MUST NOT count as a registered account.
- If the account is registered, the application MUST complete sign-in and display the Hives dashboard.
- If the account is not registered, the application MUST display the Sign-up form described in SIGNIN-006.
- Sign-up MUST be considered successful only after the required profile details have been persisted for the authenticated account. After successful sign-up, the application MUST complete registration and display the Hives dashboard.
- A user MUST complete sign-up before accessing Hive features if their account is not already registered.

### Session and Completion Behavior

- On application launch and whenever the authentication state changes, the application MUST evaluate the current authenticated session and registration status before displaying protected Hive features.
- A user with no valid authenticated session MUST be routed to the Sign-in screen. A user with a valid session and a complete registered profile MUST be routed to the Hives dashboard. A user with a valid session but no complete registered profile MUST be routed to the Sign-up form.
- When a user signs out, the application MUST clear the authenticated session and return to the Sign-in screen. Hive features MUST NOT remain accessible after sign-out.
- If a user leaves or closes the application before signup profile details are successfully persisted, registration MUST remain incomplete. On the next launch, a valid session MUST resume at the Sign-up form; without a valid session, the user MUST start at the Sign-in screen. In either case, Hive features MUST remain inaccessible until registration is complete.
- If profile persistence fails during signup, the application MUST keep the user on the Sign-up flow, show a recoverable error, and allow the user to retry. The failure MUST NOT be treated as successful registration.

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

### Acceptance Criteria

- Google and Apple sign-in MUST be available on every platform on which the application offers sign-in.
- Before a platform build is released, its Google and Apple provider configurations MUST be enabled in Supabase and the respective provider consoles. The platform-appropriate redirect URI MUST be allow-listed in Supabase, and the application MUST be configured to receive that redirect.
- After a successful provider callback, the application MUST establish a valid Supabase session before continuing to SIGNIN-002.
- If the user cancels provider sign-in, the application MUST return to the Sign-in screen without proceeding to SIGNIN-002.
- If provider authentication, redirect handling, or Supabase session establishment fails, the application MUST show a recoverable error, remain on the Sign-in flow, and MUST NOT grant access to the Hives dashboard or other Hive features.

## SIGNIN-006: Collect profile details for new accounts

Status: Accepted  
Priority: Must  
Phase: MVP

The Sign-up form MUST collect the following information from a user whose verified account is not already registered:

- Name
- Gender
- Birth date

The application MUST require all three values to complete sign-up.

The application MUST persist the required profile details associated with the user's authenticated account. If persistence fails, sign-up MUST remain incomplete and the user MUST NOT be allowed to access Hive features.
