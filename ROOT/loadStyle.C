{
    // For the canvas:
    gStyle->SetCanvasBorderMode(0);
    gStyle->SetCanvasColor(kWhite);
    gStyle->SetCanvasDefH(600); //Height of canvas
    gStyle->SetCanvasDefW(900); //Width of canvas
    gStyle->SetCanvasDefX(0);   //POsition on screen

    // For the frame:
    gStyle->SetFrameBorderMode(0);
    gStyle->SetFrameBorderSize(1);
    gStyle->SetFrameFillColor(0);
    gStyle->SetFrameFillStyle(0);
    gStyle->SetFrameLineColor(1);
    gStyle->SetFrameLineStyle(1);
    gStyle->SetFrameLineWidth(1);

    gStyle->SetEndErrorSize(2);
    //  gStyle->SetErrorMarker(20);
    gStyle->SetErrorX(0.);
    gStyle->SetMarkerStyle(20);

    //For the fit/function:
    gStyle->SetOptFit(1111);
    gStyle->SetFitFormat("5.4g");
    gStyle->SetFuncColor(2);
    gStyle->SetFuncStyle(1);
    gStyle->SetFuncWidth(2);

    // For the statistics box:
    gStyle->SetOptFile(0);
    gStyle->SetOptStat("e"); 
    gStyle->SetStatColor(kWhite);
    gStyle->SetStatFont(42);
    gStyle->SetStatFontSize(0.025);
    gStyle->SetStatTextColor(1);
    gStyle->SetStatFormat("6.4g");
    gStyle->SetStatBorderSize(1);
    gStyle->SetStatH(0.1);
    gStyle->SetStatW(0.15);
    // gStyle->SetStatStyle(Style_t style = 1001);
    // gStyle->SetStatX(Float_t x = 0);
    // gStyle->SetStatY(Float_t y = 0);

    // Margins:
    gStyle->SetPadTopMargin(0.12);
    gStyle->SetPadBottomMargin(0.13);
    gStyle->SetPadLeftMargin(0.1);
    gStyle->SetPadRightMargin(0.07);

    // For the Global title:
    gStyle->SetOptTitle(1);
    gStyle->SetTitleBorderSize(0);
    gStyle->SetTitleFontSize(0.05);
    gStyle->SetTitleTextColor(kBlack);
    gStyle->SetTitleFillColor(kWhite);
 
    // For the axis titles:
    gStyle->SetTitleColor(1, "XYZ");
    gStyle->SetTitleFont(42, "XYZ");
    gStyle->SetTitleSize(0.06, "XYZ");
    gStyle->SetTitleXOffset(0.9);
    gStyle->SetTitleYOffset(1.10);
  

    // For the axis labels:
    gStyle->SetLabelColor(1, "XYZ");
    gStyle->SetLabelFont(42, "XYZ");
    gStyle->SetLabelOffset(0.007, "XYZ");
    gStyle->SetLabelSize(0.05, "XYZ");

    // For the axis:
    gStyle->SetAxisColor(1, "XYZ");
    gStyle->SetLabelSize(0.05, "XY");
    gStyle->SetTitleSize(0.05, "XY");
    gStyle->SetStripDecimals(kTRUE);
    gStyle->SetTickLength(0.03, "XYZ");
    gStyle->SetNdivisions(510, "XYZ");
    // To get tick marks on the opposite side of the frame
    gStyle->SetPadTickX(1);  
    gStyle->SetPadTickY(1);

    // Change for log plots:
    gStyle->SetOptLogx(0);
    gStyle->SetOptLogy(0);
    gStyle->SetOptLogz(0);

}
