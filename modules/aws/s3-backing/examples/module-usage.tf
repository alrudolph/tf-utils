module "s3_backing" {
  source = "github.com/alrudolph/tf-utils/modules/aws/s3-backing/module"

  bucket_name = "<my-bucket-name>"
  table_name  = "<my-table-name>"
}
