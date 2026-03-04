local Nova = require("@pesde/nova")

local Home = {}

function Home.Get() 
    return Nova.response({ msg = "Hello World" })
end

function Home.Head() 
    return Nova.response("")
end

return Home