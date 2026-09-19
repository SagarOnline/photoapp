# API Contracts

## Create Collection

POST /collections

Request

{
  "name": "Goa Trip 2026"
}

Response

{
  "id": "uuid",
  "inviteCode": "ABCD1234"
}

---

## Join Collection

POST /collections/join

{
  "inviteCode": "ABCD1234"
}

---

## Upload Media

POST /media

Multipart upload.

Returns media metadata.

---

## List Media

GET /collections/{collectionId}/media

Returns ordered media list.