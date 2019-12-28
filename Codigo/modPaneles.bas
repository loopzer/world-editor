Attribute VB_Name = "modPaneles"
'**************************************************************
'This program is free software; you can redistribute it and/or modify
'it under the terms of the GNU General Public License as published by
'the Free Software Foundation; either version 2 of the License, or
'any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'GNU General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'
'Argentum Online is based on Baronsoft's VB6 Online RPG
'You can contact the original creator of ORE at aaron@baronsoft.com
'for more information about ORE please visit http://www.baronsoft.com/
'**************************************************************

''
' modPaneles
'
' @remarks Funciones referentes a los Paneles de Funcion
' @author gshaxor@gmail.com
' @version 0.3.28
' @date 20060530

Option Explicit
Private device As Integer
Private pic As MyPicture
Public Sub InitPanelModule(holder As MyPicture)
    Set pic = holder
    device = wGL_Graphic.Create_Device_From_Display(pic.hwnd, pic.ScaleWidth, pic.ScaleHeight)
    
    Call Invalidate(pic.hwnd)
End Sub

Public Sub DestroyPanelModule()
    wGL_Graphic.Destroy_Device (device)
End Sub

Public Sub Render()
    Call wGL_Graphic.Use_Device(device)
    Call wGL_Graphic.Clear(CLEAR_COLOR Or CLEAR_DEPTH Or CLEAR_STENCIL, &H0, 1#, 0)
    Call wGL_Graphic_Renderer.Update_Projection(&H0, pic.ScaleWidth, pic.ScaleHeight)
    
    
    If MosaicoChecked Then
        Dim X As Integer, Y As Integer
        
        For X = 1 To mAncho
            For Y = 1 To MAlto
                If CurrentGrh(X, Y).grhIndex Then
                    With GrhData(CurrentGrh(X, Y).grhIndex)
                        Call DrawGrhIndex(.Frames(1), 0, 0, -1#, 0)
                    End With
                End If
            Next Y
        Next X
    Else
        If CurrentGrh(0).grhIndex > 0 Then
            With GrhData(CurrentGrh(0).grhIndex)
                Call DrawGrhIndex(.Frames(1), 0, 0, -1#, 0)
            End With
        End If
    End If

    Call wGL_Graphic_Renderer.Flush
End Sub

' Activa/Desactiva el Estado de la Funcion en el Panel Superior
'
' @param Numero Especifica en numero de funcion
' @param Activado Especifica si esta o no activado

Public Sub EstSelectPanel(ByVal Numero As Byte, ByVal Activado As Boolean)
'*************************************************
'Author: ^[GS]^
'Last modified: 30/05/06
'*************************************************

    If Activado Then
        frmMain.SelectPanel(Numero).GradientMode = lv_Bottom2Top
        frmMain.SelectPanel(Numero).HoverBackColor = frmMain.SelectPanel(Numero).GradientColor
        If frmMain.mnuVerAutomatico.Checked = True Then
            Select Case Numero
                Case 0
                    If CurLayer <> 1 Then
                        frmMain.mnuVerCapa(CurLayer).Tag = CInt(frmMain.mnuVerCapa(CurLayer).Checked)
                        frmMain.mnuVerCapa(CurLayer).Checked = True
                            
                        bVerCapa(CurLayer) = True
                    End If
                Case 2
                    frmMain.cVerBloqueos.Tag = CInt(frmMain.cVerBloqueos.Value)
                    frmMain.cVerBloqueos.Value = True
                    frmMain.mnuVerBloqueos.Checked = frmMain.cVerBloqueos.Value
                Case 6
                    frmMain.cVerTriggers.Tag = CInt(frmMain.cVerTriggers.Value)
                    frmMain.cVerTriggers.Value = True
                    frmMain.mnuVerTriggers.Checked = frmMain.cVerTriggers.Value
            End Select
        End If
    Else
        frmMain.SelectPanel(Numero).HoverBackColor = frmMain.SelectPanel(Numero).BackColor
        frmMain.SelectPanel(Numero).GradientMode = lv_NoGradient
        
        If frmMain.mnuVerAutomatico.Checked Then
            Select Case Numero
                Case 0
                    If CurLayer <> 1 Then
                        If LenB(frmMain.mnuVerCapa(CurLayer).Tag) <> 0 Then
                            frmMain.mnuVerCapa(CurLayer).Checked = CBool(frmMain.mnuVerCapa(CurLayer).Tag)
                            bVerCapa(CurLayer) = frmMain.mnuVerCapa(CurLayer).Checked
                        End If
                    End If
                Case 2
                    If LenB(frmMain.cVerBloqueos.Tag) = 0 Then frmMain.cVerBloqueos.Tag = 0
                    frmMain.cVerBloqueos.Value = CBool(frmMain.cVerBloqueos.Tag)
                    frmMain.mnuVerBloqueos.Checked = frmMain.cVerBloqueos.Value
                Case 6
                    If LenB(frmMain.cVerTriggers.Tag) = 0 Then frmMain.cVerTriggers.Tag = 0
                    frmMain.cVerTriggers.Value = CBool(frmMain.cVerTriggers.Tag)
                    frmMain.mnuVerTriggers.Checked = frmMain.cVerTriggers.Value
            End Select
        End If
    End If
End Sub

''
' Muestra los controles que componen a la funcion seleccionada del Panel
'
' @param Numero Especifica el numero de Funcion
' @param Ver Especifica si se va a ver o no
' @param Normal Inidica que ahi que volver todo No visible

Public Sub VerFuncion(ByVal Numero As Byte, ByVal Ver As Boolean, Optional Normal As Boolean)
'*************************************************
'Author: ^[GS]^
'Last modified: 20/05/06
'*************************************************
    If Normal Then Call VerFuncion(vMostrando, False, False)
    
    Select Case Numero
        Case 0 ' Superficies
            frmMain.lListado(0).Visible = Ver
            frmMain.cFiltro(0).Visible = Ver
            frmMain.cCapas.Visible = Ver
            frmMain.cGrh.Visible = Ver
            frmMain.cQuitarEnEstaCapa.Visible = Ver
            frmMain.cQuitarEnTodasLasCapas.Visible = Ver
            frmMain.cSeleccionarSuperficie.Visible = Ver
            frmMain.lbFiltrar(0).Visible = Ver
            frmMain.lbCapas.Visible = Ver
            frmMain.lbGrh.Visible = Ver
            frmMain.PreviewGrh.Visible = Ver
            If Ver = True Then
                frmMain.StatTxt.Top = 672
                frmMain.StatTxt.Height = 37
            Else
                frmMain.StatTxt.Top = 416
                frmMain.StatTxt.Height = 293
            End If
        Case 1 ' Translados
            frmMain.lMapN.Visible = Ver
            frmMain.lXhor.Visible = Ver
            frmMain.lYver.Visible = Ver
            frmMain.tTMapa.Visible = Ver
            frmMain.tTX.Visible = Ver
            frmMain.tTY.Visible = Ver
            frmMain.cInsertarTrans.Visible = Ver
            frmMain.cInsertarTransOBJ.Visible = Ver
            frmMain.cUnionManual.Visible = Ver
            frmMain.cUnionAuto.Visible = Ver
            frmMain.cQuitarTrans.Visible = Ver
        Case 2 ' Bloqueos
            frmMain.cQuitarBloqueo.Visible = Ver
            frmMain.cInsertarBloqueo.Visible = Ver
            frmMain.cVerBloqueos.Visible = Ver
        Case 3  ' NPCs
            frmMain.lListado(1).Visible = Ver
            frmMain.cFiltro(1).Visible = Ver
            frmMain.lbFiltrar(1).Visible = Ver
            frmMain.lNumFunc(Numero - 3).Visible = Ver
            frmMain.cNumFunc(Numero - 3).Visible = Ver
            frmMain.cInsertarFunc(Numero - 3).Visible = Ver
            frmMain.cQuitarFunc(Numero - 3).Visible = Ver
            frmMain.cAgregarFuncalAzar(Numero - 3).Visible = Ver
            frmMain.lCantFunc(Numero - 3).Visible = Ver
            frmMain.cCantFunc(Numero - 3).Visible = Ver
        Case 4 ' NPCs Hostiles
            frmMain.lListado(2).Visible = Ver
            frmMain.cFiltro(2).Visible = Ver
            frmMain.lbFiltrar(2).Visible = Ver
            frmMain.lNumFunc(Numero - 3).Visible = Ver
            frmMain.cNumFunc(Numero - 3).Visible = Ver
            frmMain.cInsertarFunc(Numero - 3).Visible = Ver
            frmMain.cQuitarFunc(Numero - 3).Visible = Ver
            frmMain.cAgregarFuncalAzar(Numero - 3).Visible = Ver
            frmMain.lCantFunc(Numero - 3).Visible = Ver
            frmMain.cCantFunc(Numero - 3).Visible = Ver
        Case 5 ' OBJs
            frmMain.lListado(3).Visible = Ver
            frmMain.cFiltro(3).Visible = Ver
            frmMain.lbFiltrar(3).Visible = Ver
            frmMain.lNumFunc(Numero - 3).Visible = Ver
            frmMain.cNumFunc(Numero - 3).Visible = Ver
            frmMain.cInsertarFunc(Numero - 3).Visible = Ver
            frmMain.cQuitarFunc(Numero - 3).Visible = Ver
            frmMain.cAgregarFuncalAzar(Numero - 3).Visible = Ver
            frmMain.lCantFunc(Numero - 3).Visible = Ver
            frmMain.cCantFunc(Numero - 3).Visible = Ver
        Case 6 ' Triggers
            frmMain.cQuitarTrigger.Visible = Ver
            frmMain.cInsertarTrigger.Visible = Ver
            frmMain.cVerTriggers.Visible = Ver
            frmMain.lListado(4).Visible = Ver
    End Select
    
    If Ver Then
        vMostrando = Numero
        If Numero < 0 Or Numero > 6 Then Exit Sub
        If frmMain.SelectPanel(Numero).Value = False Then
            frmMain.SelectPanel(Numero).Value = True
        End If
    Else
        If Numero < 0 Or Numero > 6 Then Exit Sub
        If frmMain.SelectPanel(Numero).Value = True Then
            frmMain.SelectPanel(Numero).Value = False
        End If
    End If
End Sub

''
' Filtra del Listado de Elementos de una Funcion
'
' @param Numero Indica la funcion a Filtrar

Public Sub Filtrar(ByVal Numero As Byte)
'*************************************************
'Author: ^[GS]^
'Last modified: 26/05/06
'*************************************************

    Dim vDatos As String
    Dim I As Long
    Dim Filtro As String
    
    If frmMain.cFiltro(Numero).ListCount > 5 Then
        frmMain.cFiltro(Numero).RemoveItem 0
    End If
    
    frmMain.cFiltro(Numero).AddItem frmMain.cFiltro(Numero).Text
    frmMain.lListado(Numero).Clear
        
    Filtro = frmMain.cFiltro(Numero).Text
    
    Select Case Numero
        Case 0 ' superficie
            For I = 0 To MaxSup
                vDatos = SupData(I).name
                
                If (LenB(Filtro) = 0) Or (InStr(1, UCase$(vDatos), UCase$(Filtro))) Then
                    frmMain.lListado(Numero).AddItem vDatos & " - #" & I
                End If
            Next I
            
        Case 1 ' NPCs
            For I = 1 To NumNPCs
                If Not NpcData(I).Hostile Then
                    vDatos = NpcData(I).name
                    
                    If (LenB(Filtro) = 0) Or (InStr(1, UCase$(vDatos), UCase$(Filtro))) Then
                        frmMain.lListado(Numero).AddItem vDatos & " - #" & I
                    End If
                End If
            Next I
        Case 2 ' NPCs Hostiles
            For I = 1 To NumNPCs
                If NpcData(I).Hostile Then
                    vDatos = NpcData(I).name
                    
                    If (LenB(Filtro) = 0) Or (InStr(1, UCase$(vDatos), UCase$(Filtro))) Then
                        frmMain.lListado(Numero).AddItem vDatos & " - #" & I
                    End If
                End If
            Next I
            
        Case 3 ' Objetos
            For I = 1 To NumOBJs
                vDatos = ObjData(I).name
                
                If (LenB(Filtro) = 0) Or (InStr(1, UCase$(vDatos), UCase$(Filtro))) Then
                    frmMain.lListado(Numero).AddItem vDatos & " - #" & I
                End If
            Next I
    End Select
End Sub

Public Function DameGrhIndex(ByVal GrhIn As Integer) As Integer
'*************************************************
'Author: Unkwown
'Last modified: 20/05/06
'*************************************************

DameGrhIndex = SupData(GrhIn).Grh
End Function

Public Sub ActualizarMosaico()
If MosaicoChecked Then
    mAncho = Val(frmConfigSup.mAncho)
    MAlto = Val(frmConfigSup.mLargo)
    
    ReDim CurrentGrh(1 To mAncho, 1 To MAlto) As Grh
Else
    ReDim CurrentGrh(0) As Grh
End If

Call fPreviewGrh(frmMain.cGrh.Text)
Call Render
End Sub

Public Sub fPreviewGrh(ByVal GrhIn As Integer)
'*************************************************
'Author: Unkwown
'Last modified: 22/05/06
'*************************************************
Dim X As Byte
Dim Y As Byte

If Val(GrhIn) < 1 Then
    frmMain.cGrh.Text = UBound(GrhData)
    Exit Sub
End If

If Val(GrhIn) > UBound(GrhData) Then
    frmMain.cGrh.Text = 1
    Exit Sub
End If

If MosaicoChecked Then
    For Y = 1 To MAlto
        For X = 1 To mAncho
            'Change CurrentGrh
            If Not fullyBlack(GrhIn) Then
                InitGrh CurrentGrh(X, Y), GrhIn
            Else
                InitGrh CurrentGrh(X, Y), 0
            End If
            
            GrhIn = GrhIn + 1
        Next X
    Next Y
Else
    If Not fullyBlack(GrhIn) Then
        InitGrh CurrentGrh(0), GrhIn
    Else
        InitGrh CurrentGrh(0), 0
    End If
End If
End Sub
