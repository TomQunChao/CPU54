# mips54条指令多周期CPU--verilog实现

## 方法：

- 看8条指令的PPT
- **画通路图**
- **打时序表**
- 写代码
- debug

## 坑：

- 和别人比对结果的时候注意结果和tb文件配套使用
- 写的时候一定要做好备份。我的就被我误删了。~~删库真爽~~
- 后仿真的时候如果xxxx，先降频
- vivado自带simulator后仿真如果一直卡在elobrate步骤，可以尝试使用modelsim

## 技巧

- tb文件可以使用以下格式把波形添加到窗口，就像对象的层级访问。也可以配合$fdisplay输出到文件

  ```verilog
  wire [5:0]status=sdf.sccpu.c.status;//添加Control模块的status到波形
  wire [5:0]aluc=sdf.sccpu.c.aluc//输入输出端口也可以
  ```

- output可以当作wire类型使用