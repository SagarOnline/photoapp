# Hive Joining Requirements

## JOIN-001: Share an invite to join Hive

Status: Accepted
Priority: Must
Phase: MVP

A user should be able to share a Hive invite through a link or code, including WhatsApp.

## JOIN-002: Require a registered account to join a Hive

Status: Accepted  
Priority: Must  
Phase: MVP

A user MUST be signed in to a registered account before joining a Hive. A user without an account MUST complete sign-up as described in [signin.md](signin.md) before joining. Anonymous and guest joins are not supported.

### Acceptance Criteria

- An invalid invite code produces a friendly error.
- A valid invite can be used to join only by a signed-in user.
- A successful join creates a member record associated with the user's account.