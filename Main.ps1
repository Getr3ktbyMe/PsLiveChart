#########################################################################
# Author:  Kevin RAHETILAHY                                             #   
# Blog: dev4sys.blogspot.fr                                             #
#########################################################################

#########################################################################
#                        Add shared_assemblies                          #
#########################################################################


[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.dll')        | out-null  	
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.Wpf.dll') 	 | out-null  	


#########################################################################
#                        Load Main Panel                                #
#########################################################################

$Global:pathPanel= split-path -parent $MyInvocation.MyCommand.Definition


function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}


$XamlMainWindow=LoadXaml($pathPanel+"\Main.xaml")
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form = [Windows.Markup.XamlReader]::Load($reader)


#########################################################################
#                        Load Views Panel                               #
#########################################################################

$viewFolder = $pathPanel +"\views"

$XamlChildWindow = LoadXaml($viewFolder+"\geoMap.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$GeoMapXaml        = [Windows.Markup.XamlReader]::Load($Childreader)


$XamlChildWindow = LoadXaml($viewFolder+"\lineChart.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$LineChartXaml     = [Windows.Markup.XamlReader]::Load($Childreader)


$XamlChildWindow = LoadXaml($viewFolder+"\doughnut.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$DoughnutXaml   = [Windows.Markup.XamlReader]::Load($Childreader)

$XamlChildWindow = LoadXaml($viewFolder+"\pieChart.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$PieChartXaml   = [Windows.Markup.XamlReader]::Load($Childreader)

#******************* Target View  *****************

$HamburgerMenuControl = $Form.FindName("HamburgerMenuControl")

$GeoMapView    = $Form.FindName("GeoMapView") 
$LineChartView = $Form.FindName("LineChartView")
$DoughnutView  = $Form.FindName("DoughnutView")
$PieChartView  = $Form.FindName("PieChartView") 


$GeoMapView.Children.Add($GeoMapXaml)        | Out-Null
$LineChartView.Children.Add($LineChartXaml)  | Out-Null    
$DoughnutView.Children.Add($DoughnutXaml)    | Out-Null   
$PieChartView.Children.Add($PieChartXaml)    | Out-Null  

##############################################################
#                CONTROL INITIALIZATION                      #
##############################################################



# Initialize with the first value of Item Section 
$HamburgerMenuControl.SelectedItem = $HamburgerMenuControl.ItemsSource[0]

$GeoMap    = $GeoMapXaml.FindName("GeoMap")
$lineChart = $LineChartXaml.FindName("lineChart")
$Doughnut  = $DoughnutXaml.FindName("Doughnut")
$pieChart  = $PieChartXaml.FindName("pieChart")



##############################################################
#                Line chart                                  #
##############################################################

# Data of line chart 
."$pathPanel\scripts\lineChart.ps1"  
 $lineChart.Series = $seriesCollection


##############################################################
#                GEOMAP                               #
##############################################################
$GeoMap.EnableZoomingAndPanning = $False


##############################################################
#                PieChart                                    #
##############################################################



##############################################################
#                Doughnut                                    #
##############################################################
# Data of doughnut chart 
."$pathPanel\scripts\doughnut.ps1"  
$Doughnut.Series = $DoughnutCollection



#########################################################################
#                        HAMBURGER EVENTS                               #
#########################################################################

$HamburgerMenuControl.add_ItemClick({
    
   $HamburgerMenuControl.Content = $HamburgerMenuControl.SelectedItem
   $HamburgerMenuControl.IsPaneOpen = $false

})



##############################################################
#                SHOW WINDOW                                 #
##############################################################

$Form.ShowDialog() | Out-Null

