//
// Created by nahkhiir on 07/05/23.
//

#ifndef _SPRITE_GRID_H_
#include "2d/sceneobject/ImageGridController.h"
#endif

#include <algorithm>
#include <random>

// Script bindings.
#include "2d/sceneobject/ImageGridController_ScriptBinding.h"

IMPLEMENT_CONOBJECT(ImageGridController);

const size_t DEFAULT_COLS = 8;
const size_t DEFAULT_ROWS = 8;
const size_t DEFAULT_GRID_SIZE = 10.0F;
const size_t DEFAULT_GAME_PIECE_SIZE = 10.0F;
const size_t DEFAULT_BORDER_SIZE = 8.0F;
const ColorF DEFAULT_SELECTION_COLOR = ColorF(1.0F, 0.0F, 0.0F, 1.0F);
const ColorF DEFAULT_HIGHLIGHT_COLOR = ColorF(1.0F, 0.0F, 1.0F, 1.0F);
const ColorF DEFAULT_NORMAL_COLOR = ColorF(1.0F, 1.0F, 1.0F, 1.0F);

ImageGridController::ImageGridController() : mFlipX(false), mFlipY(false), mNumCols{DEFAULT_COLS},
                                               mNumRows{DEFAULT_ROWS},
                                               mCellWidth{DEFAULT_GRID_SIZE}, mCellHeight{DEFAULT_GRID_SIZE},
                                               mBorderSize{DEFAULT_BORDER_SIZE},
                                               mMaxDistanceSwapX{DEFAULT_COLS},
                                               mMaxDistanceSwapY{DEFAULT_ROWS},
                                               mGamePieceWidth{DEFAULT_GAME_PIECE_SIZE},
                                               mGamePieceHeight{DEFAULT_GAME_PIECE_SIZE},
                                               mFirstSelectedSprite(0, 0, 0),
                                               mSecondSelectedSprite(0, 0, 0),
                                               mSelectionColor{DEFAULT_SELECTION_COLOR},
                                               mNormalColor{DEFAULT_NORMAL_COLOR}
{
    mGridWidth = mNumCols * mCellWidth;
    mGridHeight = mNumRows * mCellHeight;
    setSize(mGridWidth + (2 * mBorderSize), mGridHeight + (2 * mBorderSize));

    mGameGrid = nullptr;

    for (U32 count = 0; count < mNumRows * mNumCols; ++count)
    {
        mGameGridData.emplace_back(-1, 0, 0);
    }

    // Set as auto-sizing.
    mAutoSizing = true;
}

ImageGridController::~ImageGridController()
{

}

void ImageGridController::copyTo(SimObject *object)
{
    // Call to parent.
    Parent::copyTo(object);

    // Cast to sprite.
    ImageGridController *pSpriteGrid = static_cast<ImageGridController *>(object);

    // Sanity!
    AssertFatal(pSpriteGrid != NULL, "SpriteGrid::copyTo() - Object is not the correct type.");

    /// Render flipping.
    pSpriteGrid->setFlip(getFlipX(), getFlipY());
}

//------------------------------------------------------------------------------

void ImageGridController::initPersistFields()
{
    // Call parent.
    Parent::initPersistFields();

    /// Render flipping.
    addField("FlipX", TypeBool, Offset(mFlipX, ImageGridController), &writeFlipX, "");
    addField("FlipY", TypeBool, Offset(mFlipY, ImageGridController), &writeFlipY, "");
}

//------------------------------------------------------------------------------

bool ImageGridController::onAdd()
{
    // Call parent.
    if (!Parent::onAdd())
        return false;

    return true;
}

//-----------------------------------------------------------------------------

void ImageGridController::onRemove()
{
    // Call parent.
    Parent::onRemove();
}


void ImageGridController::sceneRender(const SceneRenderState *pSceneRenderState,
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


void ImageGridController::fillGrid(bool randomFill)
{
    U32 frame{0};
    char pos[255] = {};

    auto rd = std::random_device {};
    auto rng = std::default_random_engine {rd()};
    std::vector<int> randFrames(mNumCols * mNumRows);
    std::iota(std::begin(randFrames), std::end(randFrames), 0);
    std::shuffle(std::begin(randFrames), std::end(randFrames), rng);


    for (U32 row = 0; row < mNumRows; ++row)
    {
        for (U32 col = 0; col < mNumCols; ++col)
        {
            if (randomFill)
            {
                frame = randFrames[row * mNumCols + col];
            }
            else
            {
                frame = (mNumRows - row - 1) * mNumCols + col;
            }

                snprintf(pos, sizeof(pos), "%d %d", col, row);
                U32 newSprite = mGameGrid->addSprite(SpriteBatchItem::LogicalPosition(pos));

                mGameGridData[row * mNumCols + col].mSpriteId = newSprite;
                mGameGridData[row * mNumCols + col].mFrame = frame;
                mGameGridData[row * mNumCols + col].mTileValue = (mNumRows - row - 1) * mNumCols + col;

                mGameGrid->setSpriteImage(mGameImageAssetName.c_str(), frame);

        }
    }
}

bool ImageGridController::registerImageGrid(CompositeSprite *pSceneObject)
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

U32 ImageGridController::gamePieceClickSelect(const Vector2& mouseWorldPosition)
{
    U32 row{0};
    U32 col{0};
    U32 spriteId{0};

    //check click pos is on grid and return row/col clicked
    if (worldPointToGridCoords(mouseWorldPosition, row, col))
    {
        //code==-1 indicates empty cell
        if (mGameGridData[row * mNumCols + col].mFrame >= 0)
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

bool ImageGridController::worldPointToGridCoords(const Vector2& worldPoint, U32 &row, U32 &col)
{
    Vector2 localPoint = getLocalPoint(worldPoint);

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

bool ImageGridController::checkValidSwap(SelectedSprite firstSelection, SelectedSprite secondSelection)
{
    //check horizontal swap
    S32 selectionDistanceX = firstSelection.mSpriteCol - secondSelection.mSpriteCol;
    S32 selectionDistanceY = firstSelection.mSpriteRow - secondSelection.mSpriteRow;
    if (std::abs(selectionDistanceY) <= mMaxDistanceSwapY && std::abs(selectionDistanceX) <= mMaxDistanceSwapX)
    {
        return true;
    }

    //no valid swap
    return false;
}

void ImageGridController::swapSprites(SelectedSprite firstSelection, SelectedSprite secondSelection)
{

    U32 firstIndex = firstSelection.mSpriteRow * mNumCols + firstSelection.mSpriteCol;
    U32 secondIndex = secondSelection.mSpriteRow * mNumCols + secondSelection.mSpriteCol;
    ImageGridData tempData;

    tempData.mSpriteId = firstSelection.mSpriteId;
    tempData.mFrame = mGameGridData[firstIndex].mFrame;

    if (mGameGrid->selectSpriteId(firstSelection.mSpriteId))
    {
        mGameGrid->setSpriteImage(mGameImageAssetName.c_str(), mGameGridData[secondIndex].mFrame);
        mGameGridData[firstIndex].mFrame = mGameGridData[secondIndex].mFrame;
    }

    if (mGameGrid->selectSpriteId(secondSelection.mSpriteId))
    {
        mGameGrid->setSpriteImage(mGameImageAssetName.c_str(), tempData.mFrame);
        mGameGridData[secondIndex].mFrame = tempData.mFrame;
    }
}

void ImageGridController::addGameImage(const char *pImageAssetId)
{
    // Finish if invalid image asset.
    if ( pImageAssetId == NULL )
        return;

    mGameImageAssetName = std::string(pImageAssetId);

    // Set asset.
    mGameImage.setAssetId( pImageAssetId );

    updateGameImageSettings();

}

void ImageGridController::updateGameImageSettings()
{
    mGameImage->setCellWidth(mGameImage->getImageWidth() / mNumCols);
    mGameImage->setCellHeight(mGameImage->getImageHeight() / mNumRows);
    mGameImage->setCellCountX(mNumCols);
    mGameImage->setCellCountY(mNumRows);

}

F64 ImageGridController::calcImageScore()
{
    F64 imageScore{0.0F};

    for (auto & imageTile : mGameGridData)
    {
        if (imageTile.mFrame == imageTile.mTileValue)
        {
            imageScore += 1.0F;
        }
    }

    imageScore /= (mNumCols * mNumRows);

    return imageScore;
}









