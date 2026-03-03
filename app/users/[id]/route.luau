local Nova = require("@pesde/nova")

local UserId = {}

function UserId.Get(req: Nova.RequestWith<{ id: string }>) 
    local id = req.params.id
    return Nova.response({ msg = "Hello World", IdFound = id })
end

return UserId