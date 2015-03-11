unit U_Common;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, CRGrid, ComCtrls, 
  ToolWin,Menus, ImgList, DB, MemDS, DBAccess, MyAccess, DBCtrls, OleCtrls,
  SHDocVw,grproLib_TLB,StdCtrls,AdoDb;

type
  PTTreeNodeData = ^TTreeNodeData;
  TTreeNodeData = class
      m_ItemProtocol:Byte;//protocol_645_97 或 protocol_645_07
      m_ItemID:Integer;
      m_ItemDI:LongWord;
      m_ItemCtrl:Byte;
      m_ItemName:string;
      m_ItemFormat:string;
      m_ItemData:string;
      m_ItemCheckData:string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const exit_traversal_value = 1;//退出遍历码
type pTv_traversal_of_object = function(Sender: TObject; Node: TTreeNode):Int64 of object;
type pTv_traversal           = function(Sender: TObject; Node: TTreeNode):Int64;

function TraversalTreeNode(tv:TTreeView;tv_node:TTreeNode;pFunc:pTv_traversal_of_object;pg_Func:pTv_traversal):Int64;//遍历子节点
function GetTreeNode(tv:TTreeView;tv_node:TTreeNode;DNO:Int64):TTreeNode;//从tv_node开始，查找m_DNO=DNO的节点
function TDataTypeToGrDataType(srcDataType:TDataType):Integer;//从TDataType类型转化到Grid++report的字段数据类型

function DeleteNodeData(Sender: TObject; Node: TTreeNode):Int64;

implementation

function DeleteNodeData(Sender: TObject; Node: TTreeNode):Int64;
begin
    if Assigned(Node.Data) then
    begin
        TTreeNodeData(Node.Data).Free;
        Node.Data := nil;
    end;
end;

function TDataTypeToGrDataType(srcDataType:TDataType):Integer;//从TDataType类型转化到Grid++report的字段数据类型
begin
    case srcDataType of
        ftSmallint,
        ftInteger,
        ftWord,
        ftLargeint,
        ftVariant,
        ftAutoInc,
        ftBytes,
        ftVarBytes:
        begin
            Result:=grftInteger;
        end;
        ftFloat:
        begin
            Result:=grftFloat;
        end;
        else
        begin
            Result:=grftString;
        end;
    end;
end;

function TraversalTreeNode(tv:TTreeView;tv_node:TTreeNode;pFunc:pTv_traversal_of_object;pg_Func:pTv_traversal):Int64;//遍历子节点
var child_node:TTreeNode;
begin
    Result := 0;
    if ( tv.Items.Count <=0 ) then
        Exit;
    if tv_node = nil then
        tv_node := tv.Items.GetFirstNode;
    if tv_node<>nil then
    begin
        //回调
        if Assigned(pFunc)    then
        begin
            Result := pFunc  (tv,tv_node);
            if  Result = exit_traversal_value then Exit;
        end;
        if Assigned(pg_Func)  then
        begin
            Result := pg_Func(tv,tv_node);
            if  Result = exit_traversal_value then Exit;
        end;

        child_node := tv_node.getFirstChild;
        if child_node<>nil then
        begin
            Result := TraversalTreeNode(tv,child_node,pFunc,pg_Func);
            if Result = exit_traversal_value then Exit;
        end;
        while child_node<>nil do
        begin
            child_node := tv_node.GetNextChild(child_node);
            if child_node<>nil then
            begin
                Result := TraversalTreeNode(tv,child_node,pFunc,pg_Func);
                if Result = exit_traversal_value then Exit;
            end;
        end;
    end;
end;

//tv_node = nil 则从根节点开始查找
var nDNO:Int64;
    TreeNode_Tmp:TTreeNode;
function GetTreeNode_Tmp(Sender: TObject; Node: TTreeNode):Int64;
begin
  {
    if (Assigned(Node.Data)) and (TTreeNodeData(Node.Data).m_DNO = nDNO) then
    begin
        TreeNode_Tmp := Node;
        Result := exit_traversal_value;
    end;
    }
end;
function GetTreeNode(tv:TTreeView;tv_node:TTreeNode;DNO:Int64):TTreeNode;
var child_node,tmpResult:TTreeNode;
begin
    nDNO := DNO;
    TreeNode_Tmp := nil;
    TraversalTreeNode(tv,tv_node,nil,GetTreeNode_Tmp);
    Result := TreeNode_Tmp;
end;

end.
