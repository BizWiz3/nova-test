local Nova = require("@pesde/nova")

local Home = {}

function Home.Get() 
    return Nova.response({ msg = "Hello World" })
end

return Home