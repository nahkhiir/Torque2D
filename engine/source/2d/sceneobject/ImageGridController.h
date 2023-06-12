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

enum class GridUpdateDirection {
    NONE,
    DOWN,
    UP
};

enum class MatchType
{
    NONE,
    ROW,
    COLUMN
};

struct GridData
{
    GridData()
    {
        mCode = 0;
        mSpriteId = 0;
        mBlocking = false;
    }

    GridData(S32 code, U32 ID, bool active) : mCode{code}, mSpriteId{ID}, mBlocking{active}{};

    S32 mCode;
    U32 mSpriteId;
    bool mBlocking;
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

struct GameMatch
{
    GameMatch()
    {
        mMatchType = MatchType::NONE;
        mPieceCode = 0;
        mStartPos = 0;
        mCount = 0;
    }

    GameMatch(MatchType type, S32 code, U32 pos, U32 count) : mMatchType{type}, mPieceCode{code}, mStartPos{pos}, mCount{count}{};

    MatchType mMatchType;
    S32 mPieceCode;
    U32 mStartPos;
    U32 mCount;
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

    bool registerSpriteGrid(CompositeSprite *pSceneObject);

    void addGamePieceImage(const char *pAssetID);
    void addGamePieceAnimation(const char *pAssetID);

    void fillGrid(bool useImages);

    U32 gamePieceClickSelect (const Vector2& mouseWorldPosition);
    bool localPointToGridCoords(const Vector2& localPoint, U32& row, U32& col);
    bool checkValidSwap(SelectedSprite firstSelection, SelectedSprite secondSelection);
    void swapSprites(SelectedSprite firstSelection, SelectedSprite secondSelection);

    U32 checkForMatches();
    void addMatch(MatchType type, S32 code, U32 pos, U32 count);
    void highlightMatchingPieces();
    void clearMatchingPieces();
    void postMatchGridUpdate();

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

    GridUpdateDirection mUpdateDirection;
    bool mAllowHorizontalMatching;
    bool mAllowVerticalMatching;
    U32 mMinimumNumberRowMatching;
    U32 mMinimumNumberColumnMatching;

    ColorF mSelectionColor;
    ColorF mHighlightColor;
    ColorF mNormalColor;

    std::vector<std::string> mGamePieceImages;
    std::vector<std::string> mGamePieceAnimations;
    std::vector<GridData> mGameGridData;
    std::vector<GameMatch> mGameMatches;
    CompositeSprite *mGameGrid;

};

#endif //_IMAGE_GRID_CONTROLLER_H_
