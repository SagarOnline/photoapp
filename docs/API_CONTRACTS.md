# API Contracts

## Create Hive

POST /hives

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

## Join Hive

POST /hives/join

{
  "inviteCode": "ABCD1234"
}

---

## Upload Media

POST /media

Multipart upload.

Returns media metadata.

---

## List Hive Media

GET /hives/{hiveId}/media

Returns ordered media list.