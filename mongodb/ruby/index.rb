require 'mongo'

# Global variables
$redis = nil
$collection = nil
$db = nil

$host = ENV['MONGO_HOST'] 
$user = ENV['USER'] 
$password = ENV['PASSWORD'] 
$database =ENV['DATABASE'] 

$messages = Array[]
$messages.clear 

Mongo::Logger.logger.level = Logger::FATAL #To disable Debug Logs

#Methods
def Connect()
    client = Mongo::Client.new([ "#{$host}:27017" ], :database => $database)
    $messages.push("Connecting to MongoDB")
    $db = client.database
    $collection = client[:users] #Selecting users collection
    $messages.push("Selecting user collection")
end


def CreateCollection()
    $messages.append("Creating User Collection just inserting a new document")
end

def DeleteCollection()
    $collection.drop()
    $messages.append("Deleting collection")
end

def AddUser(user)
    result = $collection.insert_one(user)
    $messages.append("Adding user to collection")
    result.inserted_id 
end

def GetUser(id)
    user = $collection.find( { _id: BSON::ObjectId(id) } ).first
    $messages.append("Getting user #{user} from collection")
end

def GetUsers()
    $messages.append("Querying all users from collection")
    $collection.find.each do | user |
        $messages.append("---> Printing user #{user} from collection")
    end  
end

def DeleteUser(id)
    result = $collection.delete_one( { id: id } )
    result.deleted_count # returns 1 because one document was deleted
    $messages.append("Deleting user with #{id}")
end

def DeleteAllUsers
    $collection.delete_many({})
    $messages.append("Deleting all users from collection")
end

def randomString()
    charset = Array('A'..'Z') + Array('a'..'z')
    return Array.new(10) { charset.sample }.join
end


begin
    #Calling methods
    Connect()
    CreateCollection()
    user = {name: 'User - ' + randomString, hobbies: [ randomString, randomString ]}
    id = AddUser(user)
    GetUser(id)

    user2 = {name: 'User - ' + randomString, hobbies: [ randomString, randomString ]}
    id2 = AddUser(user2)

    GetUsers()
    DeleteUser(id)
    DeleteAllUsers()
    DeleteCollection()

    for message in $messages
        p message
    end 

rescue => error
    p "Raising error: #{ error }"
ensure

end
