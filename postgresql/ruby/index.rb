#!/usr/bin/ruby

require 'pg'

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
    $conn = PG.connect :host => $host, :port => 5432, :dbname => $database, :user => $user, :password => $password
    $messages.push("Connected to Postgres")
end

def CreateTable()
    # #Check if table exists and drop it
    DeleteTable()

    $conn.exec "
        CREATE TABLE Users (
            id serial PRIMARY KEY, 
            name VARCHAR(50) NOT NULL, 
            lastname VARCHAR(50) NOT NULL
        );"

    $messages.append("Creating Table Users")
end

def DeleteTable()
    result = $conn.exec "DROP TABLE IF EXISTS Users"
    $messages.append("Dropping Table Users")
end

def AddUser(name, lastname)
    result = $conn.exec "INSERT INTO Users (Name, LastName) VALUES ('#{name}', '#{ lastname }')"
    $messages.append("Adding user with Name: #{ name } and lastName: #{ lastname }")
end

def GetUser(id)
    result = $conn.exec "SELECT * FROM Users Where Id = #{ id }"
    user = result.values
    $messages.append("Getting user: #{ user } from Users")
end

def GetUsers()
    $messages.append("Getting all users from table")
    results = $conn.exec "SELECT * FROM Users"
    results.each do | user |  
        $messages.append("---> Printing user #{ user } from Users Table")
    end 
end

def DeleteUser(id)
    result = $conn.exec "DELETE FROM Users WHERE Id='#{ id }'"
    $messages.append("Deleting user with #{id}")
end

def DeleteAllUsers()
    result = $conn.exec "DELETE FROM Users"
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

rescue PG::Error => pgerror
    p "Raising Postgres error: #{ pgerror }"
rescue => error
    p "Raising error: #{ error }"
ensure
    $conn.close if $conn
end






