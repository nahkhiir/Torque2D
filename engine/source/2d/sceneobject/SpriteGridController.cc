//
// Created by nahkhiir on 07/05/23.
//

#ifndef _SPRITE_GRID_H_
#include "2d/sceneobject/SpriteGridController.h"
#endif

#include "mRandom.h"

#include <algorithm>

// Script bindings.
#include "2d/sceneobject/SpriteGridController_ScriptBinding.h"

IMPLEMENT_CONOBJECT(SpriteGridController);

const size_t DEFAULT_COLS = 8;
const size_t DEFAULT_ROWS = 8;
const size_t DEFAULT_GRID_SIZE = 8.0F;
const size_t DEFAULT_GAME_PIECE_SIZE = 7.0F;
const size_t DEFAULT_BORDER_SIZE = 8.0F;
const ColorF DEFAULT_SELECTION_COLOR = ColorF(1.0F, 0.0F, 0.0F, 1.0F);
const ColorF DEFAULT_HIGHLIGHT_COLOR = ColorF(1.0F, 0.0F, 1.0F, 1.0F);
const ColorF DEFAULT_NORMAL_COLOR = ColorF(1.0F, 1.0F, 1.0F, 1.0F);

SpriteGridController::SpriteGridController() : mFlipX(false), mFlipY(false), mNumCols{DEFAULT_COLS},
                                               mNumRows{DEFAULT_ROWS},
                                               mCellWidth{DEFAULT_GRID_SIZE}, mCellHeight{DEFAULT_GRID_SIZE},
                                               mBorderSize{DEFAULT_BORDER_SIZE},
                                               mMaxDistanceSwapX{1},
                                               mMaxDistanceSwapY{1},
                                               mGamePieceWidth{DEFAULT_GAME_PIECE_SIZE},
                                               mGamePieceHeight{DEFAULT_GAME_PIECE_SIZE},
                                               mFirstSelectedSprite(0, 0, 0),
                                               mSecondSelectedSprite(0, 0, 0),
                                               mUpdateDirection{GridUpdateDirection::DOWN},
                                               mAllowHorizontalMatching{true},
                                               mAllowVerticalMatching{false},
                                               mMinimumNumberRowMatching{3},
                                               mMinimumNumberColumnMatching{3},
                                               mSelectionColor{DEFAULT_SELECTION_COLOR},
                                               mHighlightColor{DEFAULT_HIGHLIGHT_COLOR},
                                               mNormalColor{DEFAULT_NORMAL_COLOR}
{
    mGridWidth = mNumCols * mCellWidth;
    mGridHeight = mNumRows * mCellHeight;
    setSize(mGridWidth + (2 * mBorderSize), mGridHeight + (2 * mBorderSize));

    mGameGrid = nullptr;

    for (U32 count = 0; count < mNumRows * mNumCols; ++count)
    {
        mGameGridData.emplace_back(-1, 0, false);
    }

    // Set as auto-sizing.
    mAutoSizing = true;
}

SpriteGridController::~SpriteGridController()
{

}

void SpriteGridController::copyTo(SimObject *object)
{
    // Call to parent.
    Parent::copyTo(object);

    // Cast to sprite.
    SpriteGridController *pSpriteGrid = static_cast<SpriteGridController *>(object);

    // Sanity!
    AssertFatal(pSpriteGrid != NULL, "SpriteGrid::copyTo() - Object is not the correct type.");

    /// Render flipping.
    pSpriteGrid->setFlip(getFlipX(), getFlipY());
}

//------------------------------------------------------------------------------

void SpriteGridController::initPersistFields()
{
    // Call parent.
    Parent::initPersistFields();

    /// Render flipping.
    addField("FlipX", TypeBool, Offset(mFlipX, SpriteGridController), &writeFlipX, "");
    addField("FlipY", TypeBool, Offset(mFlipY, SpriteGridController), &writeFlipY, "");
}

//------------------------------------------------------------------------------

bool SpriteGridController::onAdd()
{
    // Call parent.
    if (!Parent::onAdd())
        return false;

    return true;
}

//-----------------------------------------------------------------------------

void SpriteGridController::onRemove()
{
    // Call parent.
    Parent::onRemove();
}


void SpriteGridController::sceneRender(const SceneRenderState *pSceneRenderState,
                                       const SceneRenderRequest *pSceneRenderRequest,
                                       BatchRender *pBatchRenderer)
{
    // Let the parent render.
    ImageFrameProvider::render(
            getFlipX(), getFlipY(),
            mRenderOOBB[0],
            mRenderOOBB[1],
            mRenderOOBB[2],
            mRenderOOBB[3],
            pBatchRenderer);

    //if (mGameGrid->getSpriteCount() > 0)
    //{
    //    mGameGrid.render(pSceneRenderState, pSceneRenderRequest, pBatchRenderer);
    //}
}

void SpriteGridController::addGamePieceImage(const char *pAssetID)
{
    mGamePieceImages.emplace_back(pAssetID);
}

void SpriteGridController::addGamePieceAnimation(const char *pAssetID)
{
    mGamePieceAnimations.emplace_back(pAssetID);
}

void SpriteGridController::fillGrid(bool useImages)
{
    const U32 frame{0};
    char pos[255] = {};
    U32 gamePiece{0};
    RandomPCG rng;


    for (U32 row = 0; row < mNumRows; ++row)
    {
        for (U32 col = 0; col < mNumCols; ++col)
        {
            //filling an empty grid
            if (mGameGridData[row * mNumCols + col].mSpriteId == 0)
            {
                snprintf(pos, sizeof(pos), "%d %d", col, row);
                U32 newSprite = mGameGrid->addSprite(SpriteBatchItem::LogicalPosition(pos));

                if (useImages)
                {
                    gamePiece = rng.randI(mGamePieceImages.size());
                    mGameGrid->setSpriteImage(mGamePieceImages[gamePiece].c_str(), frame);
                } else
                {
                    gamePiece = rng.randI(mGamePieceAnimations.size());
                    mGameGrid->setSpriteAnimation(mGamePieceAnimations[gamePiece].c_str());
                }
                mGameGridData[row * mNumCols + col].mSpriteId = newSprite;
                mGameGridData[row * mNumCols + col].mCode = gamePiece;
            }
            //refill blanks after clearing matches
            else
            {
                if (mGameGridData[row * mNumCols + col].mCode == -1)
                {
                    mGameGrid->selectSpriteId(mGameGridData[row * mNumCols + col].mSpriteId);
                    if (useImages)
                    {
                        gamePiece = rng.randI(mGamePieceImages.size());
                        mGameGrid->setSpriteImage(mGamePieceImages[gamePiece].c_str(), frame);
                    } else
                    {
                        gamePiece = rng.randI(mGamePieceAnimations.size());
                        mGameGrid->setSpriteAnimation(mGamePieceAnimations[gamePiece].c_str());
                    }
                    mGameGridData[row * mNumCols + col].mCode = gamePiece;
                }
            }
        }
    }
}

bool SpriteGridController::registerSpriteGrid(CompositeSprite *pSceneObject)
{
    if (mGameGrid != nullptr)
    {
        return false;
    }

    mGameGrid = pSceneObject;

    //align composite sprite to background
    Vector2 controllerPosition = getPosition();
    controllerPosition.x -= (mGridWidth / 2 - mCellWidth / 2);
    controllerPosition.y -= (mGridHeight / 2 - mCellHeight / 2);
    mGameGrid->setPosition(controllerPosition);

    mGameGrid->setSize(mGridWidth, mGridHeight);
    mGameGrid->setDefaultSpriteSize(Vector2(mGamePieceWidth, mGamePieceHeight));
    mGameGrid->setDefaultSpriteStride(Vector2(mCellWidth, mCellHeight));
    mGameGrid->setBatchLayout(CompositeSprite::RECTILINEAR_LAYOUT);

    return true;
}

U32 SpriteGridController::gamePieceClickSelect(const Vector2& mouseWorldPosition)
{
    U32 row{0};
    U32 col{0};
    U32 spriteId{0};

    //check click pos is on grid and return row/col clicked
    if (localPointToGridCoords(mouseWorldPosition, row, col))
    {
        //code==-1 indicates empty cell
        if (mGameGridData[row * mNumCols + col].mCode >= 0)
        {
            spriteId = mGameGridData[row * mNumCols + col].mSpriteId;

            if (mFirstSelectedSprite.mSpriteId == 0)
                //nothing selected yet so highlight red
            {
                if (mGameGrid->selectSpriteId(spriteId))
                {
                    mGameGrid->setSpriteBlendColor(mSelectionColor);
                    mFirstSelectedSprite.mSpriteId = spriteId;
                    mFirstSelectedSprite.mSpriteRow = row;
                    mFirstSelectedSprite.mSpriteCol = col;
                }
            } else
            {
                if (mFirstSelectedSprite.mSpriteId == spriteId)
                    //same sprite clicked again so deselect and unhighlight
                {
                    mGameGrid->selectSpriteId(spriteId);
                    mGameGrid->setSpriteBlendColor(ColorF(1.0F, 1.0F, 1.0F, 1.0F));
                    mFirstSelectedSprite.mSpriteId = 0;
                    mFirstSelectedSprite.mSpriteRow = 0;
                    mFirstSelectedSprite.mSpriteCol = 0;
                } else
                    //second sprite clicked
                {
                    mSecondSelectedSprite.mSpriteId = spriteId;
                    mSecondSelectedSprite.mSpriteRow = row;
                    mSecondSelectedSprite.mSpriteCol = col;
                    if (checkValidSwap(mFirstSelectedSprite, mSecondSelectedSprite))
                    {
                        //swap is valid so reset highlighting on first sprite
                        mGameGrid->selectSpriteId(mFirstSelectedSprite.mSpriteId);
                        mGameGrid->setSpriteBlendColor(ColorF(1.0F, 1.0F, 1.0F, 1.0F));
                        swapSprites(mFirstSelectedSprite, mSecondSelectedSprite);

                        //reset selection trackers
                        mFirstSelectedSprite.mSpriteId = 0;
                        mFirstSelectedSprite.mSpriteRow = 0;
                        mFirstSelectedSprite.mSpriteCol = 0;

                        mSecondSelectedSprite.mSpriteId = 0;
                        mSecondSelectedSprite.mSpriteRow = 0;
                        mSecondSelectedSprite.mSpriteCol = 0;
                    } else
                        //not a valid swap so reset second selection tracker, leave first sprite selected
                    {
                        mSecondSelectedSprite.mSpriteId = 0;
                        mSecondSelectedSprite.mSpriteRow = 0;
                        mSecondSelectedSprite.mSpriteCol = 0;
                    }
                }
            }
        }
    }
    return spriteId;
}

bool SpriteGridController::localPointToGridCoords(const Vector2& localPoint, U32 &row, U32 &col)
{
    //point is left of or below grid then return false
    if ((localPoint.x < -mGridWidth / 2) || (localPoint.y < -mGridHeight / 2))
    {
        return false;
    }

    //point is right of or above grid then return false
    if ((localPoint.x > mGridWidth / 2) || (localPoint.y > mGridHeight / 2))
    {
        return false;
    }

    row = static_cast<int>(localPoint.y + mGridWidth / 2);
    row /= mCellWidth;
    col = static_cast<int>(localPoint.x + mGridHeight / 2);
    col /= mCellHeight;

    return true;
}

bool SpriteGridController::checkValidSwap(SelectedSprite firstSelection, SelectedSprite secondSelection)
{
    //check horizontal swap
    S32 selectionDistance = firstSelection.mSpriteCol - secondSelection.mSpriteCol;
    if (firstSelection.mSpriteRow == secondSelection.mSpriteRow && std::abs(selectionDistance) <= mMaxDistanceSwapX)
    {
        return true;
    }

    //check vertical swap
    selectionDistance = firstSelection.mSpriteRow - secondSelection.mSpriteRow;
    if (firstSelection.mSpriteCol == secondSelection.mSpriteCol && std::abs(selectionDistance) <= mMaxDistanceSwapY)
    {
        return true;
    }

    //no valid swap
    return false;
}

void SpriteGridController::swapSprites(SelectedSprite firstSelection, SelectedSprite secondSelection)
{
    const U32 frame{0};
    U32 firstIndex = firstSelection.mSpriteRow * mNumCols + firstSelection.mSpriteCol;
    U32 secondIndex = secondSelection.mSpriteRow * mNumCols + secondSelection.mSpriteCol;
    GridData tempData;

    tempData.mSpriteId = firstSelection.mSpriteId;
    tempData.mCode = mGameGridData[firstIndex].mCode;

    if (mGameGrid->selectSpriteId(firstSelection.mSpriteId))
    {
        mGameGrid->setSpriteImage(mGamePieceImages[mGameGridData[secondIndex].mCode].c_str(), frame);
        mGameGridData[firstIndex].mCode = mGameGridData[secondIndex].mCode;
    }

    if (mGameGrid->selectSpriteId(secondSelection.mSpriteId))
    {
        mGameGrid->setSpriteImage(mGamePieceImages[tempData.mCode].c_str(), frame);
        mGameGridData[secondIndex].mCode = tempData.mCode;
    }
}

U32 SpriteGridController::checkForMatches()
{
    mGameMatches.clear();

    if (mMinimumNumberRowMatching > 0)
    {
        for (U32 row = 0; row < mNumRows; ++row)
        {
            S32 currentCode{0};
            U32 foundCount{0};

            //get code of first piece in row
            currentCode = mGameGridData[row * mNumCols].mCode;
            foundCount = 1;

            for (U32 col = 1; col < mNumCols; ++col)
            {
                if (mGameGridData[row * mNumCols + col].mCode != currentCode)
                {
                    if (foundCount >= mMinimumNumberRowMatching)
                    {
                        addMatch(MatchType::ROW, currentCode, (row * mNumCols + col - foundCount), foundCount);
                    }
                    currentCode = mGameGridData[row * mNumCols + col].mCode;
                    foundCount = 1;
                } else
                {
                    ++foundCount;
                    //special case for end of row
                    if (col + 1 == mNumCols && foundCount >= mMinimumNumberRowMatching)
                    {
                        addMatch(MatchType::ROW, currentCode, (row * mNumCols + col + 1 - foundCount), foundCount);
                    }
                }
            }
        }
    }

    if (mMinimumNumberColumnMatching > 0)
    {
        for (U32 col = 0; col < mNumCols; ++col)
        {
            S32 currentCode{0};
            U32 foundCount{0};

            //get code of first piece in row
            currentCode = mGameGridData[col].mCode;
            foundCount = 1;

            for (U32 row = 1; row < mNumRows; ++row)
            {
                if (mGameGridData[row * mNumCols + col].mCode != currentCode)
                {
                    if (foundCount >= mMinimumNumberColumnMatching)
                    {
                        addMatch(MatchType::COLUMN, currentCode, (row * mNumCols + col - foundCount * mNumCols), foundCount);
                    }
                    currentCode = mGameGridData[row * mNumCols + col].mCode;
                    foundCount = 1;
                } else
                {
                    ++foundCount;
                    //special case for top of col
                    if (row + 1 == mNumRows && foundCount >= mMinimumNumberColumnMatching)
                    {
                        addMatch(MatchType::COLUMN, currentCode, ((row + 1) * mNumCols + col - foundCount * mNumCols), foundCount);
                    }
                }
            }
        }
    }

    return mGameMatches.size();
}

void SpriteGridController::addMatch(MatchType type, S32 code, U32 pos, U32 count)
{
    //ignore code == -1 as its empty cell
    //possibly a hack but its cleaner to just ignore here than complicate the match finding routing
    if (code >= 0)
    {
        mGameMatches.emplace_back(GameMatch{type, code, pos, count});
    }
}

void SpriteGridController::clearMatchingPieces()
{
    if (mGameMatches.empty())
    {
        return;
    }

    for (auto & match : mGameMatches)
    {
        if (match.mMatchType == MatchType::ROW)
        {
            for (U32 index = match.mStartPos; index < match.mStartPos + match.mCount; ++index)
            {
                mGameGridData[index].mCode = -1;
                mGameGrid->selectSpriteId(mGameGridData[index].mSpriteId);
                mGameGrid->clearSpriteAsset();
            }
        }
        else if (match.mMatchType == MatchType::COLUMN)
        {
            for (U32 index = match.mStartPos; index < match.mStartPos + match.mCount * mNumCols; index += mNumCols)
            {
                mGameGridData[index].mCode = -1;
                mGameGrid->selectSpriteId(mGameGridData[index].mSpriteId);
                mGameGrid->clearSpriteAsset();
            }
        }
    }
}

void SpriteGridController::postMatchGridUpdate()
{
    //TODO
}

void SpriteGridController::highlightMatchingPieces()
{
    if (mGameMatches.empty())
    {
        return;
    }

    //reset highlighting
    for (auto & piece : mGameGridData)
    {
        mGameGrid->selectSpriteId(mGameGridData[piece.mSpriteId].mSpriteId);
        mGameGrid->setSpriteBlendColor(mNormalColor);
    }

    for (auto & match : mGameMatches)
    {
        if (match.mMatchType == MatchType::ROW)
        {
            for (U32 index = match.mStartPos; index < match.mStartPos + match.mCount; ++index)
            {
                mGameGrid->selectSpriteId(mGameGridData[index].mSpriteId);
                mGameGrid->setSpriteBlendColor(mHighlightColor);
            }
        }
        else if (match.mMatchType == MatchType::COLUMN)
        {
            for (U32 index = match.mStartPos; index < match.mStartPos + match.mCount * mNumCols; index += mNumCols)
            {
                mGameGrid->selectSpriteId(mGameGridData[index].mSpriteId);
                mGameGrid->setSpriteBlendColor(mHighlightColor);
            }
        }
    }
}








