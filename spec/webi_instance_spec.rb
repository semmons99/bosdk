$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'bosdk/webi_instance'

module BOSDK
  describe WebiInstance do
    before(:each) do
      @document_instance = mock("DocumentInstance").as_null_object

      @webi = WebiInstance.new(@document_instance)
    end

    describe "#new" do
      it "should store the passed DocumentInstance in @doc_instance" do
        @webi.instance.should == @document_instance
      end
    end

    describe "#objects" do
      before(:each) do
        @report_dictionary = mock("ReportDictionary").as_null_object
        @report_expression_1 = mock("ReportExpression").as_null_object
        @report_expression_2 = mock("ReportExpression").as_null_object
        @object_qualification_1 = mock("ObjectQualification").as_null_object
        @object_qualification_2 = mock("ObjectQualification").as_null_object
        @object_type_1 = mock("ObjectType").as_null_object
        @object_type_2 = mock("ObjectType").as_null_object

        @document_instance.should_receive(:getDictionary).once.with.and_return(@report_dictionary)

        @report_dictionary.should_receive(:getChildCount).once.with.and_return(2)
        @report_dictionary.should_receive(:getChildAt).once.with(0).and_return(@report_expression_1)
        @report_dictionary.should_receive(:getChildAt).once.with(1).and_return(@report_expression_2)

        @report_expression_1.should_receive(:getName).once.with.and_return("Object1")
        @report_expression_1.should_receive(:getQualification).once.with.and_return(@object_qualification_1)
        @report_expression_1.should_receive(:getType).once.with.and_return(@object_type_1)

        @report_expression_2.should_receive(:getName).once.with.and_return("Object2")
        @report_expression_2.should_receive(:getQualification).once.with.and_return(@object_qualification_2)
        @report_expression_2.should_receive(:getType).once.with.and_return(@object_type_2)

        @object_qualification_1.should_receive(:getString).once.with.and_return("DIMENSION")
        @object_qualification_2.should_receive(:getString).once.with.and_return("MEASURE")

        @object_type_1.should_receive(:getString).once.with.and_return("TEXT")
        @object_type_2.should_receive(:getString).once.with.and_return("NUMERIC")
      end

      it "should return an array of report objects" do
        @objects = [
          {:name => 'Object1', :qual => :dimension, :type => :text, :object => @report_expression_1},
          {:name => 'Object2', :qual => :measure, :type => :numeric, :object => @report_expression_2},
        ]
        @webi.objects.should == @objects
      end

      it "should cache results" do
        2.times{@webi.objects}
      end
    end

    describe "#variables" do
      before(:each) do
        @report_dictionary = mock("ReportDictionary").as_null_object
        @variable_expression_1 = mock("VariableExpression").as_null_object
        @variable_expression_2 = mock("VariableExpression").as_null_object
        @object_qualification_1 = mock("ObjectQualification").as_null_object
        @object_qualification_2 = mock("ObjectQualification").as_null_object
        @object_type_1 = mock("ObjectType").as_null_object
        @object_type_2 = mock("ObjectType").as_null_object
        @formula_expression_1 = mock("FormulaExpression").as_null_object
        @formula_expression_2 = mock("FormulaExpression").as_null_object

        @document_instance.should_receive(:getDictionary).once.with.and_return(@report_dictionary)
        @report_dictionary.should_receive(:getVariables).once.with.and_return([@variable_expression_1, @variable_expression_2])

        @variable_expression_1.should_receive(:getName).once.with.and_return("Variable1")
        @variable_expression_1.should_receive(:getQualification).once.with.and_return(@object_qualification_1)
        @variable_expression_1.should_receive(:getType).once.with.and_return(@object_type_1)
        @variable_expression_1.should_receive(:getFormula).once.with.and_return(@formula_expression_1)

        @variable_expression_2.should_receive(:getName).once.with.and_return("Variable2")
        @variable_expression_2.should_receive(:getQualification).once.with.and_return(@object_qualification_2)
        @variable_expression_2.should_receive(:getType).once.with.and_return(@object_type_2)
        @variable_expression_2.should_receive(:getFormula).once.with.and_return(@formula_expression_2)

        @object_qualification_1.should_receive(:getString).once.with.and_return("DIMENSION")
        @object_qualification_2.should_receive(:getString).once.with.and_return("MEASURE")

        @object_type_1.should_receive(:getString).once.with.and_return("TEXT")
        @object_type_2.should_receive(:getString).once.with.and_return("NUMERIC")

        @formula_expression_1.should_receive(:getValue).once.with.and_return('If([Object1]="Object1";"Yes";"False")')
        @formula_expression_2.should_receive(:getValue).once.with.and_return('Sum([Object2])')
      end

      it "should return an array of variables" do
        @variables = [
          {:name => 'Variable1', :qual => :dimension, :type => :text, :formula => 'If([Object1]="Object1";"Yes";"False")', :variable => @variable_expression_1},
          {:name => 'Variable2', :qual => :measure, :type => :numeric, :formula => 'Sum([Object2])', :variable => @variable_expression_2},
        ]
        @webi.variables.should == @variables
      end

      it "should cache results" do
        2.times{@webi.variables}
      end
    end
  end
end
