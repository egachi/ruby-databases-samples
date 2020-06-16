
# How to run this sample code

## Requirements
You need to set the following environment variables with your data.

- REDIS_HOST
- PASSWORD

## Rails App
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

3. To run the application with `bundle exec rails server`

    > The application will be listening by default on **http://localhost:3000**

4. You will need to compile assets for production before deploying it to Azure Web App, please use the following command:
`rake assets:precompile RAILS_ENV=production`
    
5. Create Azure Web App and deploy the app.