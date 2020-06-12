aws s3api create-bucket --bucket vurbanas-bucket --acl private;
aws s3api put-bucket-versioning --bucket vurbanas-bucket --versioning-configuration Status=Enabled;
echo "hello world" >> hello_world.txt;
aws s3 cp hello_world.txt s3://vurbanas-bucket/hello_world.txt;
rm hello_world.txt; 
