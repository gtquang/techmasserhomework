Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0
--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"
#cloud-config
cloud_final_modules:
- [scripts-user, always]
--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"
#!/bin/bash
sudo yum install -y golang
mkdir uploads3
cd uploads3
go mod init uploads3
go get github.com/kataras/iris/v12@master
tee -a file.txt <<EOF
package main

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/kataras/iris/v12"
)

const maxSize = 50 * iris.MB

func main() {
	app := iris.Default()
	app.Get("/", showHomePage)
	app.Post("/upload", handleUpload)
	app.Listen(":80")
}

func showHomePage(ctx iris.Context) {
	ctx.HTML(`
		<html>
		<body>
		<h1>Upload to S3</h1>
		<form action="/upload" method="post" enctype="multipart/form-data">
		Select file to upload:<br>
			<input type="file" name="file"><br>
			<input type="submit" value="Upload">
		</form>
		</body>
		</html>
	`)
}

func handleUpload(ctx iris.Context) {
	// Set a lower memory limit for multipart forms (default is 32 MiB)
	ctx.SetMaxRequestBodySize(maxSize)
	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion("ap-southeast-1"))
	if err != nil {
		panic("configuration error, " + err.Error())
	}

	client := s3.NewFromConfig(cfg) //Tạo S3 client

	file, fileHeader, err := ctx.FormFile("file") //Parse file từ POST request
	if err != nil {
		ctx.StopWithError(iris.StatusBadRequest, err)
		return
	}

	bucket := "quanggt.vietis.com.vn"
	input := &s3.PutObjectInput{
		Bucket:      &bucket,
		Key:         &fileHeader.Filename,
		Body:        file,
		ContentType: &fileHeader.Header["Content-Type"][0],
	}

	_, err = client.PutObject(context.TODO(), input)
	if err != nil {
		ctx.Writef("Error upload file: ", err)
	} else {
		ctx.Writef("File: %s uploaded!", fileHeader.Filename)
	}

}
EOF
go mod tidy
go build
./uploads3