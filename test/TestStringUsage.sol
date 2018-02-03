pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lib/StringsLib.sol";

contract TestStringUsage {
        function testReplace(){
                 Assert.equal(StringsLib.replace("hi there!", "there", "那儿", 1), "hi 那儿!", "hi there! should be replaced with hi 那儿!");
                 Assert.equal(StringsLib.replace("中国 北京! 你好 北京", "北京", "BeiJing", -1), "中国 BeiJing! 你好 BeiJing", "北京 should be replaced by BeiJing");
        }
        function testFind(){
            Assert.equal(StringsLib.find("hello 北京, hello ", "hello", 0) ,0, "it start with beijing");
            Assert.equal(StringsLib.find("hello 北京, hello ", "hello", 1) , 14, "it end with beijing");
        } 
        
        function testRemove(){
            Assert.equal(StringsLib.remove("中国1中国2中国3中国4中国5中国", "中国", -1), "12345", "中国被移除了");
            Assert.equal(StringsLib.remove("中国1中国2中国3中国4中国5中国", "中国", 4), "1234中国5中国", "只有一个中国可见");
        }
    
        function testLen(){
            Assert.equal(StringsLib.len("中国123＃"),12, "len(中国123＃) == 12" ) ;
        }
}
