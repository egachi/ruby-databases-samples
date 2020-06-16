require 'tiny_tds'  


# Global variables
$client = nil
$host = ENV['HOST'] 
$database =ENV['DATABASE'] 
$user = ENV['USER'] 
$password = ENV['PASSWORD'] 

$messages = Array[]
$messages.clear 

#Methods
def Connect()
    $client = TinyTds::Client.new username: $user, password: $password,  
    host: $host, port: 1433,  
    database: $database, azure:true  

    #A DBLIB connection does not have the same default SET options for a standard SMS SQL Server connection. 
    #Hence, we recommend the following options post establishing your connection.

    results = $client.execute("SET ANSI_NULLS ON")
    results = $client.execute("SET ANSI_NULL_DFLT_ON ON")    
    results = $client.execute("SET ANSI_PADDING ON")  
    results = $client.execute("SET ANSI_WARNINGS ON")  
    results = $client.execute("SET QUOTED_IDENTIFIER ON") 
    results = $client.execute("SET CURSOR_CLOSE_ON_COMMIT OFF")  
    results = $client.execute("SET IMPLICIT_TRANSACTIONS OFF")  
    results = $client.execute("SET TEXTSIZE 2147483647")
    results = $client.execute("SET CONCAT_NULL_YIELDS_NULL ON")

    if $client.active? == true then 
        $messages.append("Connected to SQL Server")
    end
end


def CreateTable()
    #Check if table exists
    result = $client.execute("SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'Users'")
    exist = result.first[""]

    if exist==1
        DeleteTable()
    end

    result = $client.execute("
        CREATE TABLE Users
        (id int IDENTITY(1,1) PRIMARY KEY,
        name varchar(50) NOT NULL,
        lastname varchar(50) NULL) 
    ")

    $messages.append("Creating Table Users")
end

def DeleteTable()
    result = $client.execute("DROP TABLE Users").do
    $messages.append("Dropping Table Users")
end

def AddUser(name, lastname)
    $messages.append("Adding user with Name: #{ name } and lastName: #{ lastname }")
    result = $client.execute("INSERT INTO Users (Name, LastName) VALUES ('#{name}', '#{ lastname }')")
    return result.insert
end

def GetUser(id)
    results = $client.execute("SELECT * FROM Users Where Id = '#{ id }'")
    user = results.each(:first => true).first
    $messages.append("Getting user: #{user} from Users")
end

def GetUsers()
    $messages.append("Getting all users from table")
    results = $client.execute("SELECT * FROM Users")  
    results.each do | user |  
        $messages.append("---> Printing user #{user} from Users Table")
    end
end

def DeleteUser(id)
    result = $client.execute("DELETE FROM Users WHERE Id='#{ id }'")
    result.do 
    $messages.append("Deleting user with #{id}")
end

def DeleteAllUsers()
    result = $client.execute("DELETE FROM Users")
    result.do 
    $messages.append("Deleting all users from collection")
end

def randomString()
    charset = Array('A'..'Z') + Array('a'..'z')
    return Array.new(10) { charset.sample }.join
end

#Calling methods

begin

    Connect()
    CreateTable()
    id = AddUser("User-#{randomString}", randomString)
    GetUser(id)
    id2 = AddUser("User-#{randomString}", randomString)
    GetUser(id2)
    GetUsers()
    DeleteUser(id)
    DeleteAllUsers()
    DeleteTable()

    for message in $messages
        p message
    end 

rescue => error
    p "Raising error: #{ error }"
ensure
    $client.close
end






