classdef Shape_t
    methods
        function instance = Shape_t(_shapeName)
          if (!exist("_shapeName","var"))
            instance.height = 171;
            instance.width = 171;
          else
            switch (_shapeName)
                
                case "Rectangle_t"
                    instance.height = 8;
                    instance.width = 5;
            endswitch
          endif
        endfunction
        function disp(_this)
            printf("Height = %d\n", (_this.height));
            printf("Width = %d\n",_this.width);
        endfunction
    endmethods
    
    methods (Access = private)
        function [outHeight,outWidth] = GetHeightWidth(_this)
            outHeight = _this.height;
            outWidth = _this.width;
        endfunction
    endmethods
    
    properties (Access = private)
        height = 8;
        width = -8;
        str1 = "string1";
        strCells = cell(10,1);
    endproperties

endclassdef
