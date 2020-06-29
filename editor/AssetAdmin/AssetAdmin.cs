//-----------------------------------------------------------------------------
// Copyright (c) 2013 GarageGames, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//-----------------------------------------------------------------------------

function AssetAdmin::create(%this)
{
	%this.guiPage = EditorCore.RegisterEditor("Asset Manager", %this);

	%this.scroller = new GuiScrollCtrl()
	{
		Profile=EditorCore.themes.scrollingPanelProfile;
		ThumbProfile = EditorCore.themes.scrollingPanelThumbProfile;
		TrackProfile = EditorCore.themes.scrollingPanelTrackProfile;
		ArrowProfile = EditorCore.themes.scrollingPanelArrowProfile;
		HorizSizing="left";
		VertSizing="height";
		Position="700 0";
		Extent="324 768";
		MinExtent="220 200";
		hScrollBar="dynamic";
		vScrollBar="alwaysOn";
		constantThumbHeight="0";
		showArrowButtons="1";
		scrollBarThickness="14";
	};
	%this.guiPage.add(%this.scroller);

	%this.testLogButton = new GuiButtonCtrl()
	{
		Profile = EditorCore.themes.buttonProfile;
		Text="Test";
		command="";
		HorizSizing="bottom";
		VertSizing="right";
		Position="0 0";
		Extent="100 30";
		MinExtent="80 20";
	};
	%this.scroller.add(%this.testLogButton);

	%this.testLogButton2 = new GuiButtonCtrl()
	{
		Profile = EditorCore.themes.buttonProfile;
		Text="Test2";
		command="";
		HorizSizing="bottom";
		VertSizing="right";
		Position="0 800";
		Extent="100 30";
		MinExtent="80 20";
	};
	%this.scroller.add(%this.testLogButton2);

	EditorCore.FinishRegistration(%this.guiPage);
}

function AssetAdmin::destroy(%this)
{

}

function AssetAdmin::onThemeChanged(%this, %theme)
{
	%this.scroller.setProfile(%theme.scrollingPanelProfile);
	%this.scroller.setThumbProfile(%theme.scrollingPanelThumbProfile);
	%this.scroller.setTrackProfile(%theme.scrollingPanelTrackProfile);
	%this.scroller.setArrowProfile(%theme.scrollingPanelArrowProfile);
}

function AssetAdmin::open(%this)
{

}

function AssetAdmin::close(%this)
{

}
