#!/usr/bin/ruby

require 'mysql2'

# Global variables
$conn = nil
$host = ENV['HOST'] 
$database =ENV['DATABASE'] 
$user = ENV['USER'] 
$password = ENV['PASSWORD'] 

$messages = Array[]
$messages.clear 

#Methods
def Connect()
    $conn = Mysql2::Client.new(:host => $host, :username => $username, :database => $database, :password => $password)
    $messages.append("Connected to MySQL")
end

def CreateTable()
    # #Check if table exists and drop it
    DeleteTable()

    $conn.query ("
    CREATE TABLE Users (
            id INT PRIMARY KEY AUTO_INCREMENT, 
            name VARCHAR(50) NOT NULL, 
            lastname VARCHAR(50) NOT NULL
        );")
    $messages.append("Creating Table Users")
end

def DeleteTable()
    result = $conn.query("DROP TABLE IF EXISTS Users")
    $messages.append("Dropping Table Users")
end

def AddUser(name, lastname)
    result = $conn.query("INSERT INTO Users (Name, LastName) VALUES ('#{name}', '#{ lastname }')")
    $messages.append("Adding user with Name: #{ name } and lastName: #{ lastname }")
end

def GetUser(id)
    result = $conn.query("SELECT * FROM Users Where Id = #{ id }").first
    user = result
    $messages.append("Getting user: #{ user } from Users")
end

def GetUsers()
    $messages.append("Getting all users from table")
    resultSet = $conn.query("SELECT * FROM Users")
    resultSet.each do | user |  
        $messages.append("---> Printing user #{ user } from Users Table")
    end 
end

def DeleteUser(id)
    result = $conn.query("DELETE FROM Users WHERE Id='#{ id }'")
    $messages.append("Deleting user with #{id}")
end

def DeleteAllUsers()
    result = $conn.query("DELETE FROM Users")
    $messages.append("Deleting all users from collection")
end

def randomString()
    charset = Array('A'..'Z') + Array('a'..'z')
    return Array.new(10) { charset.sample }.join
end


begin
    #Calling methods
    Connect()
    CreateTable()
    AddUser("User-#{randomString}", randomString)
    GetUser(1)
    AddUser("User-#{randomString}", randomString)
    GetUser(2)
    GetUsers()
    DeleteUser(1)
    DeleteAllUsers()
    DeleteTable()

    for message in $messages
        p message
    end 

rescue Mysql2::Error => mysqlerror
    p "Raising MySQL error: #{ mysqlerror }"
rescue => error
    p "Raising error: #{ error }"
ensure
    $conn.close if $conn
end






