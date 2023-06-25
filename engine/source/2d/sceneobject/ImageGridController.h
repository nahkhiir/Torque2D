//
// Created by nahkhiir on 07/05/23.
//

#ifndef _IMAGE_GRID_CONTROLLER_H_
#define _IMAGE_GRID_CONTROLLER_H_

#ifndef _SPRITE_BASE_H_
#include "2d/core/SpriteBase.h"
#endif

#ifndef _SPRITE_H_
#include "2d/sceneobject/Sprite.h"
#endif

#ifndef _COMPOSITE_SPRITE_H_
#include "2d/sceneobject/CompositeSprite.h"
#endif

#include <vector>


struct ImageGridData
{
    ImageGridData()
    {
        mFrame = 0;
        mSpriteId = 0;
        mTileValue = 0;

    }

    ImageGridData(S32 frame, U32 ID, U32 val) : mFrame{frame}, mSpriteId{ID}, mTileValue{val} {};

    S32 mFrame;
    U32 mSpriteId;
    U32 mTileValue;
};

struct SelectedSprite
{
    SelectedSprite()
    {
        mSpriteId = 0;
        mSpriteRow = 0;
        mSpriteCol = 0;
    }

    SelectedSprite(U32 Code, U32 Row, U32 Col) : mSpriteId{Code}, mSpriteRow{Row}, mSpriteCol{Col}{};

    U32 mSpriteId;
    U32 mSpriteRow;
    U32 mSpriteCol;
};


class ImageGridController : public SpriteBase
{
protected:
    typedef SpriteBase Parent;

public:
    ImageGridController();

    virtual ~ImageGridController();

    static void initPersistFields();

    virtual bool onAdd();

    virtual void onRemove();

    virtual void copyTo(SimObject *object);

    /// Render flipping.
    void setFlip(const bool flipX, const bool flipY)
    {
        mFlipX = flipX;
        mFlipY = flipY;
    }

    void setFlipX(const bool flipX)
    { setFlip(flipX, mFlipY); }

    void setFlipY(const bool flipY)
    { setFlip(mFlipX, flipY); }

    inline bool getFlipX(void) const
    { return mFlipX; }

    inline bool getFlipY(void) const
    { return mFlipY; }

    virtual void sceneRender(const SceneRenderState *pSceneRenderState, const SceneRenderRequest *pSceneRenderRequest,
                             BatchRender *pBatchRenderer);

    bool registerImageGrid(CompositeSprite *pSceneObject);
    void addGameImage(const char *pImageAssetId);
    void updateGameImageSettings();

    void fillGrid(bool randomFill);
    F64 calcImageScore();

    U32 gamePieceClickSelect (const Vector2& mouseWorldPosition);
    bool worldPointToGridCoords(const Vector2& worldPoint, U32& row, U32& col);
    bool checkValidSwap(SelectedSprite firstSelection, SelectedSprite secondSelection);
    void swapSprites(SelectedSprite firstSelection, SelectedSprite secondSelection);


    /// Declare Console Object.
    DECLARE_CONOBJECT(ImageGridController);

protected:
    static bool writeFlipX(void *obj, StringTableEntry pFieldName)
    { return static_cast<Sprite *>(obj)->getFlipX() == true; }

    static bool writeFlipY(void *obj, StringTableEntry pFieldName)
    { return static_cast<Sprite *>(obj)->getFlipY() == true; }

private:
    /// Render flipping.
    bool mFlipX;
    bool mFlipY;

    U32 mNumCols;
    U32 mNumRows;
    F32 mCellWidth;
    F32 mCellHeight;

    F32 mGridWidth;
    F32 mGridHeight;
    F32 mBorderSize;

    U32 mMaxDistanceSwapX;
    U32 mMaxDistanceSwapY;

    F32 mGamePieceWidth;
    F32 mGamePieceHeight;

    SelectedSprite mFirstSelectedSprite;
    SelectedSprite mSecondSelectedSprite;

    ColorF mSelectionColor;
    ColorF mNormalColor;

    std::vector<ImageGridData> mGameGridData;
    CompositeSprite* mGameGrid;
    AssetPtr<ImageAsset> mGameImage;
    std::string mGameImageAssetName;

    };

#endif //_IMAGE_GRID_CONTROLLER_H_
