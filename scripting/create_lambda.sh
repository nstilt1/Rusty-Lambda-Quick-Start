# Creates a lambda function ready to be compiled and sent for aarch64
# The new directory is created in the parent folder that the scripting folder is in.

# Dependencies: Cargo Lambda, Rustup, aarch64-unknown-linux-musl toolchain for rustup, Docker, Cross, AWS CLI
# Be sure to enter the AWS IAM arn on line 75

# store the name of the lambda:
name=$1
# store name of modules folder
modules=$2

# navigate to directory to add the new function
cd ..

cargo lambda new $name

# navigate to new directory
cd $name

# modify the Cargo.toml file
sed -i '5 r ../scripting/insert.txt' Cargo.toml

# if modules is set, create modules directory
if [ -n "$modules" ]; then
    cd src
    mkdir $modules
    cd $modules
    cat << EOF > mod.rs
//pub mod module_name;
//pub mod module_name_2;
//pub mod module_name_3;

EOF
    # insert module use statements in main.rs
    cd ..
    sed -i "1i mod $modules;" main.rs
    sed -i "2i //use $modules::module_name::*;" main.rs
    sed -i "3i //use $modules::module_name::*;" main.rs
    cd ..
fi

# create build.sh
cat << EOF > build.sh
export RUSTFLAGS="-Ctarget-cpu=neoverse-n1"
export RUSTFLAGS="-Ctarget-feature=+lse"

echo "COMPILING!!! Your compiled code will be ready in a moment"

# start docker if not started
ps -ef | grep -v grep | grep docker
if [ $? -eq 1 ]
then 
    # use this line if you are using WSL
    sudo service docker start
    # or use this line if you are using a VM
    #sudo systemctl start docker
fi

# build
cross build --release --target aarch64-unknown-linux-musl
#cross build --target aarch64-unknown-linux-musl
echo "creating $name.zip..."
zip -j $name.zip ./target/aarch64-unknown-linux-musl/release/bootstrap
EOF

# make it executable
sudo chmod +x ./build.sh

# create deploy.sh
cat << EOF > deploy.sh
aws lambda create-function --function-name $name \\
--handler bootstrap \\
--zip-file fileb://./$name.zip \\
--runtime provided.al2 \\
--role arn:aws:iam::yourIAMRole for the Lambda Function \\
--region us-east-1 \\
--architectures arm64
EOF

# make it executable
sudo chmod +x ./deploy.sh

# create update_func.sh
cat << EOF > update_func.sh
aws lambda update-function-code \\
--function-name $name \\
--zip-file fileb://./$name.zip \\
--region us-east-1
EOF

# make it executable
sudo chmod +x ./update_func.sh
