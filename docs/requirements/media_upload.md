# Media Upload Requirements

## MED-001: Upload Media

Status: Accepted  
Priority: Must  
Phase: MVP

A Hive member must be able to upload photos and videos to the Hive gallery.

### Acceptance Criteria

- Media is compressed before upload.
- Upload progress is visible.
- Failed uploads can be retried.
- Media metadata is stored separately from the media file.

### API and Storage Boundary

- Flutter MUST request upload authorization from the backend after compression.
- The backend MUST authorize the user as a registered member of the target Hive and issue a short-lived URL scoped to the intended R2 object.
- Flutter MUST NOT receive privileged R2 credentials.
- After upload, Flutter MUST ask the backend to record metadata. The backend MUST validate the authorized object and persist metadata in PostgreSQL.
- Gallery listing MUST be served by the backend and MUST verify Hive membership.