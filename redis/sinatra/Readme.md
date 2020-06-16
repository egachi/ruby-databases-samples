
# How to run this sample code

## Requirements
You need to set the following environment variables with your data.

- HOST
- PASSWORD

## Sinatra App
1. You need to install Ruby, this example is working fine with 2.6.2
- **Windows**: https://rubyinstaller.org
- **Linux**:
    - Ubuntu/Debian: `sudo apt-get install ruby-full`
    - CentOS/Fedora/RHEL: `sudo yum install ruby`
- **Mac**: `brew install ruby`

2. The first step is to install the required gems. There's a Gemfile included in the sample, so just run the following command:

```bash
    bundle install
```
If you don't have bundle installed, please install it first with ` gem install bundler` 
Reference: https://bundler.io/

3. To run the application with `ruby index.rb`

    > The application will be listening by default on **http://localhost:4567**
