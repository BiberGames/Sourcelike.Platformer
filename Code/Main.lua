function Start()
    LoadSprites()
    CLGameObject.SetActive("DefaultCanvas", false)
    CLGameObject.SetActive("BLOOM", false)
    CLGameObject.SetActive("DebugScreen", false)
    Sky()
    Utils.DelayedLauncher("GenerateTilemap", 2)
    Utils.DelayedLauncher("SpawnPlayer", 2)
end

function SpawnPlayer()
    CL2D.SetSprite("2DPlayer", 10)
    CLTransform.Position("2DCamera", 0, 4, 0, 0)
    CLTransform.Position("Sky", 640, 350, 50, 0)
    CL2D.SetSprite("Sky", 3)

    CL2D.SetCColliderSize("2DPlayer", 1, 1)

    CLTransform.Position("2DPlayer", 10, -8, 0, 0)

    CreateQBlock("QBlockSpawn1", 16, -6)
    CreateQBlock("QBlockSpawn2", 20, -6)
    CreateQBlock("QBlockSpawn3", 22, -6)
    CreateQBlock("QBlockSpawn3,1", 22, -2)
    CreateQBlock("QBlockSpawn4", 24, -6)

    CLGameObject.SetActive("LoadingBackground", false)
end

function LoadSprites()
    CL2D.LoadSprite("Addons/Platformer/Textures/World/BrickFloor.png", 0, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/World/Brick.png", 1, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/World/Brick2.png", 2, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/Sky.png", 3, 1, true)

    CL2D.LoadSprite("Addons/Platformer/Textures/World/QBlock1.png", 5, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/World/QBlock2.png", 6, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/World/QBlock3.png", 7, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/World/QBlock4.png", 8, 16, true)

    CL2D.LoadSprite("Addons/Platformer/Textures/Player/Player_Small_Idle.png", 10, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/Player/Player_Small_Jump.png", 11, 16, true)

    CL2D.LoadSprite("Addons/Platformer/Textures/Player/Player_Small_Walk1.png", 12, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/Player/Player_Small_Walk2.png", 13, 16, true)
    CL2D.LoadSprite("Addons/Platformer/Textures/Player/Player_Small_Walk3.png", 14, 16, true)

    CL2D.LoadSprite("Addons/Platformer/Textures/World/PL.png", 1023, 16, true)
end

function SayHi()
    CLConsole.Log("Hi!")
end

function CreateQBlock(Name, PosX, PosY)
    CLGameObject.CreateEmpty(Name)
    CLGameObject.AddComponent(Name, "2D.Sprite")
    CLGameObject.AddComponent(Name, "Physics.BoxCollider2D");
    CL2D.SetBColliderSize(Name, 1, 1)
    CL2D.SetSprite(Name, 5)
    CLTransform.Position(Name, PosX, PosY, 0, 0)
end

QAnimationFrame = 5
QTimer = 0
function QBlockAnimation(Names)

    if CLTime.GetTime() > QTimer then
        QTimer = CLTime.GetTime() + 0.3
        QAnimationFrame = QAnimationFrame + 1

        if QAnimationFrame == 8 then
            QAnimationFrame = 5
        end

        for i = 1, #Names do
            CL2D.SetSprite(Names[i], QAnimationFrame)
        end
    end
end

PWAnimationFrame = 12
PWTimer = 0
function PlayerWalkAnimation()

    if CLTime.GetTime() > PWTimer then
        PWTimer = CLTime.GetTime() + 0.2
        PWAnimationFrame = PWAnimationFrame + 1

        if PWAnimationFrame == 15 then
            PWAnimationFrame = 12
        end

        CL2D.SetSprite("2DPlayer", PWAnimationFrame)
    end
end

function PlayerAnimation()
    if not CL2D.PlayerGrounded() then
        CL2D.SetSprite("2DPlayer", 11)
    elseif CLInput.GetAxis("Horizontal") < -0.1 or CLInput.GetAxis("Horizontal") > 0.1 then
        PlayerWalkAnimation()
    else
        CL2D.SetSprite("2DPlayer", 10)
    end
end

QBlock = {"QBlockSpawn1", "QBlockSpawn2", "QBlockSpawn3", "QBlockSpawn3,1", "QBlockSpawn4"}

function Loop()
    QBlockAnimation(QBlock)
    PlayerAnimation()
end

function Sky()
    CLGameObject.CreateEmpty("Sky")
    CLGameObject.AddComponent("Sky", "2D.Sprite")
end

function UpdateTile(Name)
    CLGameObject.AddComponent(Name, "2D.Sprite")
    CLGameObject.AddComponent(Name, "Physics.BoxCollider2D");
    CL2D.SetBColliderSize(Name, 1, 1)
end

function GenerateTilemap()
    WorldRaw = CLIO.LoadFileRaw("Addons/Platformer/Maps/1-1.txt")
    World = Utils.SplitString(WorldRaw, ",")
    Index = 0
    
    for X = 1, 12, 1 do 
        for Y = 1, 210, 1 do 

            if World[Index] == "a" then
                CLConsole.Log("Nothing!")

            elseif World[Index] == "b" then
                CLGameObject.CreateEmpty("Tile" .. Index)
                UpdateTile("Tile" .. Index)
                CLTransform.Position("Tile" .. Index, Y, -X, 0, 0)
                CL2D.SetSprite("Tile" .. Index, 0)

            elseif World[Index] == "c" then
                CLGameObject.CreateEmpty("Tile" .. Index)
                UpdateTile("Tile" .. Index)
                CLTransform.Position("Tile" .. Index, Y, -X, 0, 0)
                CL2D.SetSprite("Tile" .. Index, 1)
            end

            Index = Index + 1
        end
    end
    CLConsole.Clear()
end