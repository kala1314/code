
import pandas as pd
import re

def copy_sheets():
    # '1.COPY元数据表到新建工作表“处理”中

    # 读取数据
    df = pd.read_excel('F:/1.xlsx')
    # 设置输出的文件
    writer = pd.ExcelWriter('F:/output.xlsx')
    # 有点麻烦的是相当于新建excel,需要将原来的sheets也要写入一遍
    df.to_excel(writer, 'srcData')
    df.to_excel(writer, '处理')
    writer.save()

    '''
    VBA 代码：

    Sheets("元数据—保存").Copy After:=Sheets("元数据—保存")
    Sheets("元数据—保存 (2)").Name = "处理"
    
    tips: 看起来似乎没有VBA方便的样子
    '''
def test():
	#  '2.除“工资范围”列外，找所有列中含有工资范围的，移动到对应列中
	# 考拉还没有搞定这个(原谅python新人）。。。
	pd.set_option('display.max_columns', None)
	#显示所有行
	pd.set_option('display.max_rows', None)

	df = pd.read_excel('F:/1.xlsx')
	# 确定匹配规则
	sal_reg = r'[0-9]+-[0-9]+'
	# 确定匹配范围：
	col = ['招聘人数', '工作经验要求', '应聘要求', '学历要求', '工资范围']

	for i in range(5):
	    a = re.findall(sal_reg, str(df['工资范围']))
	    print(a)
	    print(i)



def count_num():
	#'统计全表中专，大专，本科和高中出现的次数	

    df = pd.read_excel('F:/1.xlsx')
	# 为了测试方便，只统计了两列，需要统计全表吧col补充完就可以了，不过好像可以用df.columns这个获取title（后续修改）
	
    col = ['工作经验要求', '应聘要求']
    a = b = c = d = 0
	# 这里好像没有处理好(后续python基础学好后修改)
    for i in col:
        for j in df.index:
            if df[i].at[j] == '中专':
                a = a + 1
            elif df[i].at[j] == '大专':
                b = b + 1
            elif df[i].at[j] == '本科':
                c = c + 1
            elif df[i].at[j] == '高中':
                d = d + 1
	
    dic = {'科目': ['中专', '大专', '本科', '大学'], 'count': [a, b, c, d]}
    df = pd.DataFrame(dic)
    print(dic)
    # 如果要写入到sheets,用write
    df.to_excel('F:/out.xlsx')


    '''
    VBA 代码：
    Set dic = CreateObject("scripting.dictionary")
    h = Sheets("处理").Cells(Rows.Count, "a").End(xlUp).Row
    arr = Sheets("处理").Range("l1" & ":" & "n" & h)
    For i = 1 To UBound(arr)
        For j = 1 To 3
            x = arr(i, j)
            If x = "中专" Or x = "大专" Or x = "本科" Or x = "高中" Then
                dic(x) = dic(x) + 1
            Exit For
        End If
    Next
    Next
    Sheets.Add.Name = "统计"
    Sheets("统计").[a1].Resize(dic.Count) = Application.Transpose(dic.keys)
    Sheets("统计").[b1].Resize(dic.Count) = Application.Transpose(dic.items)
    '''





import pandas as pd
import re
def init():
    # 将表中姓名全部替换为数字
    writer = pd.ExcelWriter('F:/output.xlsx')
    df = pd.ExcelFile('F:/2.xlsx')
    print(df.sheet_names)
    sn = df.sheet_names
    for name in sn:
        df = pd.read_excel('F:/2.xlsx', sheet_name=name)
        for i in df.index:
            df['姓名'].at[i] = i
        df.to_excel(writer, name)
    writer.save()

def change_sheet_name():
    # '1.将所有的工作的名称进行重命名为纯数字，比如“14级本工商19班-统计”，改为“19”
    writer = pd.ExcelWriter('F:/3.xlsx')
    df = pd.ExcelFile('F:/output.xlsx')
    sn = df.sheet_names
    df2 = pd.read_excel('F:/output.xlsx')
    df2 = df2.set_index('学号')
    for sname in sn:
        s1 = re.sub('\D+', '-', sname).split('-')[1]
        df2.to_excel(writer, s1)
    writer.save()
    '''
    VBA:
     Dim regx As New RegExp
    With regx
        .Global = True
        .Pattern = "[0-9]+"
        For Each sht In Sheets
            If .Test(sht.Name) Then
                Set ss = .Execute(sht.Name)(1)
                sht.Name = ss
            End If
        Next
    End With
    '''

def new_sheets():
    # '2.在所有的工作表最开始新增加一个工作表为“统计”,字段名为“班级”,"平均分"，“0分人数”,填充数据
    df = pd.read_excel('F:/3.xlsx')
    writer = pd.ExcelWriter('F:/6.xlsx')
    df2 = pd.ExcelFile('F:/3.xlsx')
    sn = df2.sheet_names
    for sname in sn:
        df = pd.read_excel('F:/3.xlsx', sheet_name=sname)
        df.to_excel(writer, sheet_name=sname)
    df = pd.DataFrame({'班级':[], '平均分':[], '0分人数':[]})
    df.to_excel(writer, sheet_name='统计')
    writer.save()

    '''
    VBA:
        Worksheets.Add(before:=Sheets(1)).Name = "统计"
        Cells(1, 1) = "班级"
        Cells(1, 2) = "平均分"
        Cells(1, 3) = "0分人数"
    '''

def k3():
    # '3.将所有的工作表的详细数据全部放在一个“汇总”的工作表中，增加一列名为“班级”
    df = pd.read_excel('F:/3.xlsx')
    writer = pd.ExcelWriter('F:/6.xlsx')
    df2 = pd.ExcelFile('F:/3.xlsx')
    sn = df2.sheet_names
    for sname in sn:
        df = pd.read_excel('F:/3.xlsx', sheet_name=sname)
        df.to_excel(writer, sheet_name=sname)
        df3 = pd.read_excel('F:/3.xlsx', sheet_name=sname)
        dic = {
            '学号': df3['学号'],
            '姓名': df3['姓名'],
            '成绩': df3['总分'],
                }
    df = pd.DataFrame(dic)
    df.to_excel(writer, sheet_name='汇总')
    writer.save()


    '''
    VBA:
    Worksheets.Add(after:=Sheets(Worksheets.Count)).Name = "汇总"
    For Each sht In Sheets
        If sht.Name = "统计" Or sht.Name = "汇总" Then
            Sum = Sum + 1
        Else
            r = Sheets(sht.Name).Range("a65536").End(xlUp).Row
            r1 = Sheets("汇总").Range("a65536").End(xlUp).Row
            Sheets("汇总").Range("d" & r1 + 1 & ":d" & r1 + r) = sht.Name
            Sheets(sht.Name).Range("a1:c" & r).Copy Sheets("汇总").Range("a" & r1 + 1)
            
        End If
    Next
    For Each Rng In Sheets("汇总").Range("a1:a1000")
        If Rng.Value = "学号" Then
            Rows(Rng.Row).Delete
        End If
    Next
    Cells(1, 1) = "学号"
    Cells(1, 2) = "姓名"
    Cells(1, 3) = "总分"
    Cells(1, 4) = "班级"
    
    '''

def save_workbook():
    # '5.将所有工作表以工作表为工作簿名称，进行保存
    df = pd.ExcelFile('F:/3.xlsx')
    sn = df.sheet_names
    for sname in sn:
        df = pd.read_excel('F:/3.xlsx', sheet_name=sname)
        df.to_excel(r'F:/test/{}.xlsx'.format(sname))
    '''
    VBA:
    locpath = ThisWorkbook.Path
    For Each sht In Sheet
        If sht.Name <> "统计" Or sht.Name <> "汇总" Then
           sht.Copy
           ActiveWorkbook SaveAs(locpath & "\" & sht.Name)
           ActiveWorkbook.Close
        End If
    Next 
    '''





