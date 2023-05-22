project("${TORQUE_APP_NAME}")

# Detect 32bit and 64bit x86/ARM
if (CMAKE_SYSTEM_PROCESSOR MATCHES "arm")
    if (CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 8)
        set(TORQUE_CPU_ARM64 ON)
    elseif (CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 4)
        set(TORQUE_CPU_ARM32 ON)
    endif ()
else ()
    if (CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 8)
        set(TORQUE_CPU_X64 ON)
        addDef(TORQUE_64)
    elseif (CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 4)
        set(TORQUE_CPU_X32 ON)
    endif ()
endif ()

if (UNIX)
    if (NOT CXX_FLAG32)
        set(CXX_FLAG32 "")
    endif ()
    #set(CXX_FLAG32 "-m32") #uncomment for build x32 on OSx64

    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        #next line enables all warnings - comment out to suppress
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Weverything")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CXX_FLAG32} -Wundef -pipe -Wfatal-errors -Wno-return-type-c-linkage -Wno-unused-local-typedef ${TORQUE_ADDITIONAL_LINKER_FLAGS}")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CXX_FLAG32} -Wundef -pipe -Wfatal-errors -Wno-return-type-c-linkage -Wno-unused-local-typedef ${TORQUE_ADDITIONAL_LINKER_FLAGS}")

        # Only use SSE on x86 devices
        if (TORQUE_CPU_X32 OR TORQUE_CPU_X64)
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msse")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse")
        endif ()
    else ()
        # default compiler flags
        #next line enables all warnings - comment out to suppress
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CXX_FLAG32} -Wundef -pipe -Wfatal-errors -no-pie ${TORQUE_ADDITIONAL_LINKER_FLAGS} -Wl,-rpath,'$ORIGIN'")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CXX_FLAG32} -Wundef -pipe -Wfatal-errors ${TORQUE_ADDITIONAL_LINKER_FLAGS} -Wl,-rpath,'$ORIGIN'")

        # Only use SSE on x86 devices
        if (TORQUE_CPU_X32 OR TORQUE_CPU_X64)
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msse")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse")
        endif ()
    endif ()
endif ()

if (UNIX AND NOT APPLE)
    addDef(LINUX)
endif ()

set(T2D_SRC_DIR "${srcDir}")

set(T2D_SOURCE_FILES
        ${T2D_SRC_DIR}/gui/guiConsoleEditCtrl.cc
        ${T2D_SRC_DIR}/gui/guiConsole.cc
        ${T2D_SRC_DIR}/gui/guiCanvas.cc
        ${T2D_SRC_DIR}/gui/guiTextEditSliderCtrl.cc
        ${T2D_SRC_DIR}/gui/guiTypes.cc
        ${T2D_SRC_DIR}/gui/guiInputCtrl.cc
        ${T2D_SRC_DIR}/gui/editor/guiInspectorTypes.cc
        ${T2D_SRC_DIR}/gui/editor/guiEditCtrl.cc
        ${T2D_SRC_DIR}/gui/editor/guiMenuBarCtrl.cc
        ${T2D_SRC_DIR}/gui/editor/guiInspector.cc
        ${T2D_SRC_DIR}/gui/editor/guiDebugger.cc
        ${T2D_SRC_DIR}/gui/editor/guiParticleGraphInspector.cc
        ${T2D_SRC_DIR}/gui/editor/guiGraphCtrl.cc
        ${T2D_SRC_DIR}/gui/guiMessageVectorCtrl.cc
        ${T2D_SRC_DIR}/gui/guiDefaultControlRender.cc
        ${T2D_SRC_DIR}/gui/guiTreeViewCtrl.cc
        ${T2D_SRC_DIR}/gui/messageVector.cc
        ${T2D_SRC_DIR}/gui/guiArrayCtrl.cc
        ${T2D_SRC_DIR}/gui/guiColorPicker.cc
        ${T2D_SRC_DIR}/gui/guiSliderCtrl.cc
        ${T2D_SRC_DIR}/gui/buttons/guiDropDownCtrl.cc
        ${T2D_SRC_DIR}/gui/buttons/guiRadioCtrl.cc
        ${T2D_SRC_DIR}/gui/buttons/guiCheckBoxCtrl.cc
        ${T2D_SRC_DIR}/gui/buttons/guiButtonCtrl.cc
        ${T2D_SRC_DIR}/gui/guiProgressCtrl.cc
        ${T2D_SRC_DIR}/gui/guiListBoxCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiScrollCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiChainCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiSceneScrollCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiTabPageCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiExpandCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiFrameCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiGridCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiDragAndDropCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiWindowCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiTabBookCtrl.cc
        ${T2D_SRC_DIR}/gui/containers/guiPanelCtrl.cc
        ${T2D_SRC_DIR}/gui/guiTextEditCtrl.cc
        ${T2D_SRC_DIR}/gui/language/lang.cc
        ${T2D_SRC_DIR}/gui/guiControl.cc
        ${T2D_SRC_DIR}/debug/profiler.cc
        ${T2D_SRC_DIR}/debug/telnetDebugger.cc
        ${T2D_SRC_DIR}/debug/remote/RemoteDebuggerBridge.cc
        ${T2D_SRC_DIR}/debug/remote/RemoteDebuggerBase.cc
        ${T2D_SRC_DIR}/debug/remote/RemoteDebugger1.cc
        ${T2D_SRC_DIR}/bitmapFont/BitmapFontCharacter.cc
        ${T2D_SRC_DIR}/bitmapFont/BitmapFont.cc
        ${T2D_SRC_DIR}/audio/wavStreamSource.cc
        ${T2D_SRC_DIR}/audio/audioDataBlock.cc
        ${T2D_SRC_DIR}/audio/AudioAsset.cc
        ${T2D_SRC_DIR}/audio/audio_ScriptBinding.cc
        ${T2D_SRC_DIR}/audio/audioStreamSourceFactory.cc
        ${T2D_SRC_DIR}/audio/audio.cc
        ${T2D_SRC_DIR}/audio/vorbisStreamSource.cc
        ${T2D_SRC_DIR}/audio/audioBuffer.cc
        ${T2D_SRC_DIR}/audio/audioDescriptions.cc
        ${T2D_SRC_DIR}/sim/simObject.cc
        ${T2D_SRC_DIR}/sim/simDictionary.cc
        ${T2D_SRC_DIR}/sim/simBase.cc
        ${T2D_SRC_DIR}/sim/simConsoleEvent.cc
        ${T2D_SRC_DIR}/sim/simSerialize.cpp
        ${T2D_SRC_DIR}/sim/SimObjectList.cc
        ${T2D_SRC_DIR}/sim/scriptGroup.cc
        ${T2D_SRC_DIR}/sim/scriptObject.cc
        ${T2D_SRC_DIR}/sim/simFieldDictionary.cc
        ${T2D_SRC_DIR}/sim/simManager.cc
        ${T2D_SRC_DIR}/sim/simSet.cc
        ${T2D_SRC_DIR}/sim/simDatablock.cc
        ${T2D_SRC_DIR}/sim/simConsoleThreadExecEvent.cc
        ${T2D_SRC_DIR}/io/zip/zipCryptStream.cc
        ${T2D_SRC_DIR}/io/zip/zipSubStream.cc
        ${T2D_SRC_DIR}/io/zip/zipArchive.cc
        ${T2D_SRC_DIR}/io/zip/compressor.cc
        ${T2D_SRC_DIR}/io/zip/zipTempStream.cc
        ${T2D_SRC_DIR}/io/zip/extraField.cc
        ${T2D_SRC_DIR}/io/zip/zipObject.cc
        ${T2D_SRC_DIR}/io/zip/deflate.cc
        ${T2D_SRC_DIR}/io/zip/fileHeader.cc
        ${T2D_SRC_DIR}/io/zip/stored.cc
        ${T2D_SRC_DIR}/io/zip/centralDir.cc
        ${T2D_SRC_DIR}/io/fileSystem_ScriptBinding.cc
        ${T2D_SRC_DIR}/io/streamObject.cc
        ${T2D_SRC_DIR}/io/byteBuffer.cpp
        ${T2D_SRC_DIR}/io/fileStreamObject.cc
        ${T2D_SRC_DIR}/io/memStream.cc
        ${T2D_SRC_DIR}/io/fileObject.cc
        ${T2D_SRC_DIR}/io/bufferStream.cc
        ${T2D_SRC_DIR}/io/filterStream.cc
        ${T2D_SRC_DIR}/io/resizeStream.cc
        ${T2D_SRC_DIR}/io/nStream.cc
        ${T2D_SRC_DIR}/io/bitStream.cc
        ${T2D_SRC_DIR}/io/resource/resourceManager.cc
        ${T2D_SRC_DIR}/io/resource/resourceDictionary.cc
        ${T2D_SRC_DIR}/io/fileStream.cc
        ${T2D_SRC_DIR}/persistence/tinyXML/tinystr.cpp
        ${T2D_SRC_DIR}/persistence/tinyXML/tinyxmlparser.cpp
        ${T2D_SRC_DIR}/persistence/tinyXML/tinyxmlerror.cpp
        ${T2D_SRC_DIR}/persistence/tinyXML/tinyxml.cpp
        ${T2D_SRC_DIR}/persistence/taml/taml.cc
        ${T2D_SRC_DIR}/persistence/taml/xml/tamlXmlWriter.cc
        ${T2D_SRC_DIR}/persistence/taml/xml/tamlXmlParser.cc
        ${T2D_SRC_DIR}/persistence/taml/xml/tamlXmlReader.cc
        ${T2D_SRC_DIR}/persistence/taml/json/tamlJSONReader.cc
        ${T2D_SRC_DIR}/persistence/taml/json/tamlJSONWriter.cc
        ${T2D_SRC_DIR}/persistence/taml/json/tamlJSONParser.cc
        ${T2D_SRC_DIR}/persistence/taml/tamlCustom.cc
        ${T2D_SRC_DIR}/persistence/taml/binary/tamlBinaryReader.cc
        ${T2D_SRC_DIR}/persistence/taml/binary/tamlBinaryWriter.cc
        ${T2D_SRC_DIR}/persistence/taml/tamlWriteNode.cc
        ${T2D_SRC_DIR}/persistence/SimXMLDocument.cpp
        ${T2D_SRC_DIR}/algorithm/crc.cc
        ${T2D_SRC_DIR}/algorithm/hashFunction.cc
        ${T2D_SRC_DIR}/algorithm/pcg_basic.c
        ${T2D_SRC_DIR}/algorithm/Perlin.cc
        ${T2D_SRC_DIR}/messaging/eventManager.cc
        ${T2D_SRC_DIR}/messaging/scriptMsgListener.cc
        ${T2D_SRC_DIR}/messaging/message.cc
        ${T2D_SRC_DIR}/messaging/messageForwarder.cc
        ${T2D_SRC_DIR}/messaging/dispatcher.cc
        ${T2D_SRC_DIR}/assets/referencedAssets.cc
        ${T2D_SRC_DIR}/assets/assetTagsManifest.cc
        ${T2D_SRC_DIR}/assets/assetBase.cc
        ${T2D_SRC_DIR}/assets/assetFieldTypes.cc
        ${T2D_SRC_DIR}/assets/assetManager.cc
        ${T2D_SRC_DIR}/assets/assetQuery.cc
        ${T2D_SRC_DIR}/assets/declaredAssets.cc
        ${T2D_SRC_DIR}/platform/platformNetAsync.cpp
        ${T2D_SRC_DIR}/platform/platformVideo.cc
        ${T2D_SRC_DIR}/platform/platformNet.cpp
        ${T2D_SRC_DIR}/platform/platformNet_ScriptBinding.cc
        ${T2D_SRC_DIR}/platform/platformFont.cc
        ${T2D_SRC_DIR}/platform/menus/popupMenu.cc
        ${T2D_SRC_DIR}/platform/Tickable.cc
        ${T2D_SRC_DIR}/platform/platformMemory.cc
        ${T2D_SRC_DIR}/platform/nativeDialogs/fileDialog.cc
        ${T2D_SRC_DIR}/platform/nativeDialogs/msgBox.cpp
        ${T2D_SRC_DIR}/platform/platformFileIO.cc
        ${T2D_SRC_DIR}/platform/platformNet_Emscripten.cpp
        ${T2D_SRC_DIR}/platform/platform.cc
        ${T2D_SRC_DIR}/platform/CursorManager.cc
        ${T2D_SRC_DIR}/platform/platformString.cc
        ${T2D_SRC_DIR}/platform/platformCPU.cc
        ${T2D_SRC_DIR}/platform/platformAssert.cc
        ${T2D_SRC_DIR}/graphics/bitmapBmp.cc
        ${T2D_SRC_DIR}/graphics/gFont.cc
        ${T2D_SRC_DIR}/graphics/TextureManager.cc
        ${T2D_SRC_DIR}/graphics/TextureHandle.cc
        ${T2D_SRC_DIR}/graphics/bitmapJpeg.cc
        ${T2D_SRC_DIR}/graphics/TextureDictionary.cc
        ${T2D_SRC_DIR}/graphics/gBitmap.cc
        ${T2D_SRC_DIR}/graphics/bitmapPng.cc
        ${T2D_SRC_DIR}/graphics/dglMatrix.cc
        ${T2D_SRC_DIR}/graphics/bitmapPvr.cc
        ${T2D_SRC_DIR}/graphics/dgl.cc
        ${T2D_SRC_DIR}/graphics/DynamicTexture.cc
        ${T2D_SRC_DIR}/graphics/PNGImage.cpp
        ${T2D_SRC_DIR}/graphics/gPalette.cc
        ${T2D_SRC_DIR}/graphics/gColor.cc
        ${T2D_SRC_DIR}/graphics/splineUtil.cc
        ${T2D_SRC_DIR}/module/moduleManager.cc
        ${T2D_SRC_DIR}/module/moduleDefinition.cc
        ${T2D_SRC_DIR}/module/moduleMergeDefinition.cc
        ${T2D_SRC_DIR}/delegates/delegateSignal.cpp
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXCPUInfo.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXProcessControl.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXInputManager.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXOGLVideo.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXStrings.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXMemory.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXGL.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXSemaphore.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXIO.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXMutex.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXOpenAL.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXUtils.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXTime.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXMessageBox.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXInput.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXDialogs.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXWindow.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXMath_ASM.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXDedicatedStub.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXPopupMenu.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXAsmBlit.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXFileio.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXMath.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXConsole.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXFont.cc
        ${T2D_SRC_DIR}/platformX86UNIX/x86UNIXThread.cc
        ${T2D_SRC_DIR}/2d/gui/SceneWindow.cc
        ${T2D_SRC_DIR}/2d/gui/guiSpriteCtrl.cc
        ${T2D_SRC_DIR}/2d/gui/guiSceneObjectCtrl.cc
        ${T2D_SRC_DIR}/2d/gui/guiImageButtonCtrl.cc
        ${T2D_SRC_DIR}/2d/scene/SceneRenderFactories.cpp
        ${T2D_SRC_DIR}/2d/scene/ContactFilter.cc
        ${T2D_SRC_DIR}/2d/scene/DebugDraw.cc
        ${T2D_SRC_DIR}/2d/scene/SceneRenderQueue.cpp
        ${T2D_SRC_DIR}/2d/scene/WorldQuery.cc
        ${T2D_SRC_DIR}/2d/scene/Scene.cc
        ${T2D_SRC_DIR}/2d/controllers/BuoyancyController.cc
        ${T2D_SRC_DIR}/2d/controllers/AmbientForceController.cc
        ${T2D_SRC_DIR}/2d/controllers/core/PickingSceneController.cc
        ${T2D_SRC_DIR}/2d/controllers/core/GroupedSceneController.cc
        ${T2D_SRC_DIR}/2d/controllers/PointForceController.cc
        ${T2D_SRC_DIR}/2d/sceneobject/ParticlePlayer.cc
        ${T2D_SRC_DIR}/2d/sceneobject/Trigger.cc
        ${T2D_SRC_DIR}/2d/sceneobject/SceneObjectList.cc
        ${T2D_SRC_DIR}/2d/sceneobject/ShapeVector.cc
        ${T2D_SRC_DIR}/2d/sceneobject/CompositeSprite.cc
        ${T2D_SRC_DIR}/2d/sceneobject/Path.cc
        ${T2D_SRC_DIR}/2d/sceneobject/Scroller.cc
        ${T2D_SRC_DIR}/2d/sceneobject/TextSprite.cc
        ${T2D_SRC_DIR}/2d/sceneobject/LightObject.cc
        ${T2D_SRC_DIR}/2d/sceneobject/SceneObjectSet.cc
        ${T2D_SRC_DIR}/2d/sceneobject/Sprite.cc
        ${T2D_SRC_DIR}/2d/sceneobject/SceneObject.cc
        ${T2D_SRC_DIR}/2d/sceneobject/SpriteGridController.cc
        ${T2D_SRC_DIR}/2d/assets/AnimationAsset.cc
        ${T2D_SRC_DIR}/2d/assets/ParticleAssetEmitter.cc
        ${T2D_SRC_DIR}/2d/assets/ParticleAsset.cc
        ${T2D_SRC_DIR}/2d/assets/ImageAsset.cc
        ${T2D_SRC_DIR}/2d/assets/ParticleAssetField.cc
        ${T2D_SRC_DIR}/2d/assets/ParticleAssetFieldCollection.cc
        ${T2D_SRC_DIR}/2d/assets/FontAsset.cc
        ${T2D_SRC_DIR}/2d/experimental/composites/WaveComposite.cc
        ${T2D_SRC_DIR}/2d/core/RenderProxy.cc
        ${T2D_SRC_DIR}/2d/core/Vector2.cc
        ${T2D_SRC_DIR}/2d/core/CoreMath.cc
        ${T2D_SRC_DIR}/2d/core/SpriteBatchQuery.cc
        ${T2D_SRC_DIR}/2d/core/SpriteBase.cc
        ${T2D_SRC_DIR}/2d/core/Utility.cc
        ${T2D_SRC_DIR}/2d/core/ImageFrameProvider.cc
        ${T2D_SRC_DIR}/2d/core/SpriteBatch.cc
        ${T2D_SRC_DIR}/2d/core/BatchRender.cc
        ${T2D_SRC_DIR}/2d/core/ImageFrameProviderCore.cc
        ${T2D_SRC_DIR}/2d/core/SpriteBatchItem.cc
        ${T2D_SRC_DIR}/2d/core/ParticleSystem.cc
        ${T2D_SRC_DIR}/2d/editorToy/EditorToyTool.cc
        ${T2D_SRC_DIR}/2d/editorToy/EditorToySceneWindow.cc
        ${T2D_SRC_DIR}/game/defaultGame.cc
        ${T2D_SRC_DIR}/game/version.cc
        ${T2D_SRC_DIR}/game/gameConnection.cc
        ${T2D_SRC_DIR}/game/gameInterface.cc
        ${T2D_SRC_DIR}/console/consoleParser.cc
        ${T2D_SRC_DIR}/console/console.cc
        ${T2D_SRC_DIR}/console/ConsoleTypeValidators.cc
        ${T2D_SRC_DIR}/console/consoleNamespace.cc
        ${T2D_SRC_DIR}/console/consoleDoc.cc
        ${T2D_SRC_DIR}/console/CMDscan.cc
        ${T2D_SRC_DIR}/console/astAlloc.cc
        ${T2D_SRC_DIR}/console/consoleObject.cc
        ${T2D_SRC_DIR}/console/consoleBaseType.cc
        ${T2D_SRC_DIR}/console/compiledEval.cc
        ${T2D_SRC_DIR}/console/compiler.cc
        ${T2D_SRC_DIR}/console/consoleExprEvalState.cc
        ${T2D_SRC_DIR}/console/consoleLogger.cc
        ${T2D_SRC_DIR}/console/cmdgram.cc
        ${T2D_SRC_DIR}/console/consoleDictionary.cc
        ${T2D_SRC_DIR}/console/codeBlock.cc
        ${T2D_SRC_DIR}/console/arrayObject.cpp
        ${T2D_SRC_DIR}/console/consoleFunctions.cc
        ${T2D_SRC_DIR}/console/astNodes.cc
        ${T2D_SRC_DIR}/console/metaScripting_ScriptBinding.cc
        ${T2D_SRC_DIR}/console/Package.cc
        ${T2D_SRC_DIR}/console/consoleTypes.cc
        ${T2D_SRC_DIR}/string/stringUnit.cpp
        ${T2D_SRC_DIR}/string/stringBuffer.cc
        ${T2D_SRC_DIR}/string/unicode.cc
        ${T2D_SRC_DIR}/string/findMatch.cc
        ${T2D_SRC_DIR}/string/stringStack.cc
        ${T2D_SRC_DIR}/string/stringTable.cc
        ${T2D_SRC_DIR}/collection/hashTable.cc
        ${T2D_SRC_DIR}/collection/vector.cc
        ${T2D_SRC_DIR}/collection/bitTables.cc
        ${T2D_SRC_DIR}/collection/nameTags.cpp
        ${T2D_SRC_DIR}/collection/undo.cc
        ${T2D_SRC_DIR}/component/simComponent.cpp
        ${T2D_SRC_DIR}/component/behaviors/behaviorComponent.cpp
        ${T2D_SRC_DIR}/component/behaviors/behaviorTemplate.cpp
        ${T2D_SRC_DIR}/component/behaviors/behaviorInstance.cpp
        ${T2D_SRC_DIR}/component/dynamicConsoleMethodComponent.cpp
        ${T2D_SRC_DIR}/network/telnetConsole.cc
        ${T2D_SRC_DIR}/network/connectionStringTable.cc
        ${T2D_SRC_DIR}/network/tcpObject.cc
        ${T2D_SRC_DIR}/network/serverQuery.cc
        ${T2D_SRC_DIR}/network/netObject.cc
        ${T2D_SRC_DIR}/network/networkProcessList.cc
        ${T2D_SRC_DIR}/network/connectionProtocol.cc
        ${T2D_SRC_DIR}/network/netInterface.cc
        ${T2D_SRC_DIR}/network/netGhost.cc
        ${T2D_SRC_DIR}/network/netConnection.cc
        ${T2D_SRC_DIR}/network/netTest.cc
        ${T2D_SRC_DIR}/network/netDownload.cc
        ${T2D_SRC_DIR}/network/RemoteCommandEvent.cc
        ${T2D_SRC_DIR}/network/netStringTable.cc
        ${T2D_SRC_DIR}/network/httpObject.cc
        ${T2D_SRC_DIR}/network/netEvent.cc
        ${T2D_SRC_DIR}/math/mPlaneTransformer.cc
        ${T2D_SRC_DIR}/math/math_ScriptBinding.cc
        ${T2D_SRC_DIR}/math/mMathSSE.cc
        ${T2D_SRC_DIR}/math/mMathFn.cc
        ${T2D_SRC_DIR}/math/noise/RandomNumberGenerator.cc
        ${T2D_SRC_DIR}/math/noise/NoiseGenerator.cc
        ${T2D_SRC_DIR}/math/mQuat.cc
        ${T2D_SRC_DIR}/math/rectClipper.cpp
        ${T2D_SRC_DIR}/math/mBox.cc
        ${T2D_SRC_DIR}/math/mathTypes.cc
        ${T2D_SRC_DIR}/math/mMathAMD.cc
        ${T2D_SRC_DIR}/math/mMathAltivec.cc
        ${T2D_SRC_DIR}/math/mathUtils.cc
        ${T2D_SRC_DIR}/math/mQuadPatch.cc
        ${T2D_SRC_DIR}/math/mPoint.cpp
        ${T2D_SRC_DIR}/math/mRandom.cc
        ${T2D_SRC_DIR}/math/mFluid.cpp
        ${T2D_SRC_DIR}/math/mSolver.cc
        ${T2D_SRC_DIR}/math/mMatrix.cc
        ${T2D_SRC_DIR}/math/mMath_C.cc
        ${T2D_SRC_DIR}/math/mSplinePatch.cc
        ${T2D_SRC_DIR}/input/actionMap.cc
        ${T2D_SRC_DIR}/memory/dataChunker.cc
        ${T2D_SRC_DIR}/memory/frameAllocator_ScriptBinding.cc
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2Contact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2EdgeAndPolygonContact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2PolygonContact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2ContactSolver.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2EdgeAndCircleContact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2ChainAndPolygonContact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2CircleContact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2PolygonAndCircleContact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Contacts/b2ChainAndCircleContact.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/b2Body.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/b2Fixture.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/b2WorldCallbacks.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2WheelJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2MouseJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2Joint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2GearJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2RevoluteJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2FrictionJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2WeldJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2PrismaticJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2MotorJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2RopeJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2PulleyJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/Joints/b2DistanceJoint.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/b2Island.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/b2ContactManager.cpp
        ${T2D_SRC_DIR}/Box2D/Dynamics/b2World.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2CollideEdge.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2CollideCircle.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2BroadPhase.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2Distance.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2CollidePolygon.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2DynamicTree.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2TimeOfImpact.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/b2Collision.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/Shapes/b2EdgeShape.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/Shapes/b2CircleShape.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/Shapes/b2ChainShape.cpp
        ${T2D_SRC_DIR}/Box2D/Collision/Shapes/b2PolygonShape.cpp
        ${T2D_SRC_DIR}/Box2D/Particle/b2VoronoiDiagram.cpp
        ${T2D_SRC_DIR}/Box2D/Particle/b2Particle.cpp
        ${T2D_SRC_DIR}/Box2D/Particle/b2ParticleGroup.cpp
        ${T2D_SRC_DIR}/Box2D/Particle/b2ParticleSystem.cpp
        ${T2D_SRC_DIR}/Box2D/Particle/b2ParticleAssembly.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2BlockAllocator.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2Settings.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2TrackedBlock.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2Math.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2Stat.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2StackAllocator.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2Timer.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2FreeList.cpp
        ${T2D_SRC_DIR}/Box2D/Common/b2Draw.cpp
        ${T2D_SRC_DIR}/Box2D/Rope/b2Rope.cpp
        )

set(T2D_INCLUDE_PATHS
        /usr/include/freetype2
        ${libDir}libogg/include
        ${libDir}/libvorbis
        ${libDir}/libvorbis/lib
        ${libDir}/libvorbis/include
        ${libDir}/ljpeg
        ${libDir}/lpng
        ${libDir}/zlib

        ${srcDir}/

        ${srcDir}/2d
        ${srcDir}/2d/assets
        ${srcDir}/2d/controllers
        ${srcDir}/2d/controllers/core
        ${srcDir}/2d/core
        ${srcDir}/2d/editorToy
        ${srcDir}/2d/experimental/composites
        ${srcDir}/2d/gui
        ${srcDir}/2d/scene
        ${srcDir}/2d/sceneobject

        ${srcDir}/algorithm
        ${srcDir}/assets
        ${srcDir}/audio
        ${srcDir}/bitmapFont

        ${srcDir}/Box2D
        ${srcDir}/Box2D/Collision
        ${srcDir}/Box2D/Collision/Shapes
        ${srcDir}/Box2D/Common

        ${srcDir}/Box2D/Dynamics
        ${srcDir}/Box2D/Dynamics/Contacts
        ${srcDir}/Box2D/Dynamics/Joints
        ${srcDir}/Box2D/Particle
        ${srcDir}/Box2D/Rope

        ${srcDir}/collection
        ${srcDir}/component
        ${srcDir}/component/behaviors
        ${srcDir}/console
        ${srcDir}/debug
        ${srcDir}/debug/remote
        ${srcDir}/delegates
        ${srcDir}/game
        ${srcDir}/graphics

        ${srcDir}/gui
        ${srcDir}/gui/buttons
        ${srcDir}/gui/containers
        ${srcDir}/gui/editor
        ${srcDir}/gui/language

        ${srcDir}/input

        ${srcDir}/io
        ${srcDir}/io/resource
        ${srcDir}/io/zip

        ${srcDir}/math
        ${srcDir}/math/noise

        ${srcDir}/memory
        ${srcDir}/messaging
        ${srcDir}/module
        ${srcDir}/network

        ${srcDir}/persistence
        #following rapidjson ones are all required due to various folder combinations in includes
        ${srcDir}/persistence/rapidjson/include
        ${srcDir}/persistence/rapidjson/include/rapidjson
        ${srcDir}/persistence/rapidjson/include/rapidjson/internal
        ${srcDir}/persistence/taml
        ${srcDir}/persistence/tinyXML

        ${srcDir}/platform
        ${srcDir}/platform/menus
        ${srcDir}/platform/nativeDialogs
        ${srcDir}/platform/threads

        ${srcDir}/platformX86UNIX
        ${srcDir}/sim
        ${srcDir}/string
        )