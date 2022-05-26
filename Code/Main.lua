function Start()
    CLGameObject.SetActive("DefaultCanvas", false)
    CLGameObject.SetActive("BLOOM", false)
    CLGameObject.SetActive("DebugScreen", false)
    --CL2D.SetSprite("2DPlayer", "Addons/Platformer/Textures/Player_PLACEHOLDER.png", 16, true)
    Sky()
    GenerateTilemap()
end

function SayHi()
    CLConsole.Log("Hi!")
end

function Loop()
    CLTransform.Position("2DCamera", 0, 4, 0, 0)
    PlayerPosition = CLTransform.GetPosition("2DPlayer")
    CLTransform.Position("Sky", PlayerPosition[1], PlayerPosition[2], 50, 0)
end

function Sky()
    CLGameObject.CreateEmpty("Sky")
    CLGameObject.AddComponent("Sky", "2D.Sprite")
    CL2D.SetSprite("Sky", "Addons/Platformer/Textures/Sky.png", 10, true)
end

function UpdateTile(Name)
    CLGameObject.AddComponent(Name, "2D.Sprite")
    CLGameObject.AddComponent(Name, "Physics.BoxCollider2D");
    CL2D.SetColliderSize(Name, 1, 1)
end

function GenerateTilemap()
    WorldRaw = CLIO.LoadFileRaw("Addons/Platformer/Maps/0-0.txt")
    World = Utils.SplitString(WorldRaw, ",")
    Index = 0
    
    for X = 1, 12, 1 do 
        for Y = 1, 210, 1 do 
            CLConsole.Log(World[Index])
            CLGameObject.CreateEmpty("Tile" .. Index)

            if World[Index] == "a" then
                CLTransform.Position("Tile" .. Index, Y, -X, 0, 0)

            elseif World[Index] == "b" then
                UpdateTile("Tile" .. Index)
                CLTransform.Position("Tile" .. Index, Y, -X, 0, 0)
                CL2D.SetSprite("Tile" .. Index, "Addons/Platformer/Textures/World/BrickFloor.png", 16, true)

            elseif World[Index] == "c" then
                UpdateTile("Tile" .. Index)
                CLTransform.Position("Tile" .. Index, Y, -X, 0, 0)
                CL2D.SetSprite("Tile" .. Index, "Addons/Platformer/Textures/World/Brick.png", 16, true)
            end

            Index = Index + 1
        end
    end
    CLConsole.Clear()
end