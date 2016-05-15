defmodule Keyserver.KeyInfo do
    defstruct keyid: 0, vcode: ""
end

defmodule Keyserver.UserInfo do
    defstruct username: "", passwordhash: "", keys: []
end

defmodule Keyserver.UserActor do
    
end
