# GH Actions Access

Create an AWS role for GH Actions to use, connecting via OpenID

Use the created role in GH Actions:

```
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
      role-to-assume: arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME
      aws-region: us-east-1
```
