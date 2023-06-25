//
// Created by nahkhiir on 07/05/23.
//

ConsoleMethodGroupBeginWithDocs(ImageGridController, SceneObject)

//-----------------------------------------------------------------------------

/*! Add the SceneObject to the scene.
    @param sceneObject The SceneObject to add to the scene.
    @return No return value.
*/
ConsoleMethodWithDocs(ImageGridController, registerImageGrid, ConsoleBool, 3, 3, (sceneObject))
{
    // Find the specified object.
    CompositeSprite* pSceneObject = dynamic_cast<CompositeSprite*>(Sim::findObject(argv[2]));

    // Did we find the object?
    if ( !pSceneObject )
    {
        // No, so warn.
        Con::warnf("ImageGridController::registerSpriteGrid() - Could not find the specified object '%s'.", argv[2]);
        return false;
    }

    // Add to Scene.
    return object->registerImageGrid( pSceneObject );
}


//-----------------------------------------------------------------------------

/*! Fills the grid with randomly selected game pieces.
    @return No return value.
*/
ConsoleMethodWithDocs(ImageGridController, fillImageGrid, ConsoleVoid, 3, 3, (bool fillRandom))
{
    bool randomFill = dAtob(argv[2]);
    object->fillGrid(randomFill);
}


//-----------------------------------------------------------------------------

/*! Fills the grid with randomly selected game pieces.
    @return No return value.
*/

ConsoleMethodWithDocs(ImageGridController, selectGamePiece, ConsoleInt, 3, 4, (float x, float y))
{
    F32 xPos, yPos;

    const U32 elementCount = Utility::mGetStringElementCount(argv[2]);

    // ("x y")
    if ((elementCount == 2) && (argc == 3))
    {
        xPos = dAtof(Utility::mGetStringElement(argv[2], 0));
        yPos = dAtof(Utility::mGetStringElement(argv[2], 1));
    }

        // (x, [y])
    else if (elementCount == 1)
    {
        xPos = dAtof(argv[2]);

        if (argc > 3)
            yPos = dAtof(argv[3]);
        else
            yPos = xPos;
    }

        // Invalid
    else
    {
        Con::warnf("SceneObject::setSize() - Invalid number of parameters!");
        return 0;
    }

    // pass pos.
    return object->gamePieceClickSelect(Vector2(xPos, yPos));
}

//-----------------------------------------------------------------------------

/*! Sets the sprite image and optional frame.
    @param imageAssetId The image to set the sprite to.
    @param imageFrame The image frame of the imageAssetId to set the sprite to.
    @return No return value.
*/
ConsoleMethodWithDocs(ImageGridController, addGameImage, ConsoleVoid, 3, 3, (imageAssetId))
{
    // Add to Scene.
    object->addGameImage(argv[2]);
}

//-----------------------------------------------------------------------------

/*! Fills the grid with randomly selected game pieces.
    @return No return value.
*/
ConsoleMethodWithDocs(ImageGridController, getImageScore, ConsoleFloat, 2, 2, ())
{
    return object->calcImageScore();
}

ConsoleMethodGroupEndWithDocs(ImageGridController)
