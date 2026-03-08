local Nova = require("@pesde/nova")

local User = {}

function User.Get(req: Nova.RequestWith<{ username: string }>)
    local userName = req.query.username
    return Nova.response({ msg = "Hello, From Users", foundUsername = userName })
end

return User